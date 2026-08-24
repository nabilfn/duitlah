import { useAuthStore } from "@/stores/auth-store";

const API_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8080";

export interface ApiError {
  code: string;
  message: string;
  details?: Record<string, unknown>;
}

export class ApiRequestError extends Error {
  constructor(
    public status: number,
    public error: ApiError,
  ) {
    super(error.message);
    this.name = "ApiRequestError";
  }
}

interface RequestOptions extends Omit<RequestInit, "body"> {
  body?: unknown;
  /** Skip the Authorization header and the 401-triggered refresh-and-retry (used by auth endpoints themselves). */
  skipAuth?: boolean;
}

async function rawRequest(path: string, options: RequestOptions): Promise<Response> {
  const { body, headers, skipAuth, ...rest } = options;
  const token = skipAuth ? null : useAuthStore.getState().accessToken;

  return fetch(`${API_URL}${path}`, {
    ...rest,
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...headers,
    },
    body: body !== undefined ? JSON.stringify(body) : undefined,
    credentials: "include",
  });
}

async function parseErrorBody(response: Response): Promise<ApiError> {
  return response.json().catch(() => ({ code: "UNKNOWN_ERROR", message: response.statusText }));
}

// Concurrent 401s share one in-flight refresh instead of each firing their
// own POST /auth/refresh (which would race to rotate the same cookie).
let refreshPromise: Promise<string> | null = null;

async function refreshAccessToken(): Promise<string> {
  if (!refreshPromise) {
    refreshPromise = rawRequest("/api/v1/auth/refresh", { method: "POST", skipAuth: true })
      .then(async (response) => {
        if (!response.ok) {
          throw new ApiRequestError(response.status, await parseErrorBody(response));
        }
        const { accessToken } = (await response.json()) as { accessToken: string };
        useAuthStore.getState().setAccessToken(accessToken);
        return accessToken;
      })
      .finally(() => {
        refreshPromise = null;
      });
  }
  return refreshPromise;
}

async function request<T>(path: string, options: RequestOptions = {}): Promise<T> {
  let response = await rawRequest(path, options);

  // Only a request that was actually authenticated is eligible for
  // refresh-and-retry — an anonymous 401 (e.g. bad login credentials)
  // means "try again," not "your session expired."
  const wasAuthenticated = !options.skipAuth && useAuthStore.getState().accessToken !== null;
  if (response.status === 401 && wasAuthenticated) {
    try {
      await refreshAccessToken();
      response = await rawRequest(path, options);
    } catch {
      useAuthStore.getState().clearSession();
    }
  }

  if (!response.ok) {
    throw new ApiRequestError(response.status, await parseErrorBody(response));
  }

  if (response.status === 204) {
    return undefined as T;
  }

  return response.json() as Promise<T>;
}

export const apiClient = {
  get: <T>(path: string, options?: RequestOptions) =>
    request<T>(path, { ...options, method: "GET" }),
  post: <T>(path: string, body?: unknown, options?: RequestOptions) =>
    request<T>(path, { ...options, method: "POST", body }),
  put: <T>(path: string, body?: unknown, options?: RequestOptions) =>
    request<T>(path, { ...options, method: "PUT", body }),
  patch: <T>(path: string, body?: unknown, options?: RequestOptions) =>
    request<T>(path, { ...options, method: "PATCH", body }),
  delete: <T>(path: string, options?: RequestOptions) =>
    request<T>(path, { ...options, method: "DELETE" }),
};
