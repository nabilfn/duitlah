import { ApiRequestError, type ApiError } from "@/lib/api-client";

const API_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8080";

/**
 * A guest has no user session at all -- no access token, no refresh cookie -- just the opaque
 * guest token issued at join time, which the backend accepts directly in the URL path (see
 * BagilahGuestController). No refresh-and-retry dance is needed here: a guest token either works
 * for its whole 24h window or it doesn't, and there's nothing to refresh it into.
 */
async function guestRequest<T>(
  guestToken: string,
  path: string,
  options: { method: string; body?: unknown },
): Promise<T> {
  const response = await fetch(`${API_URL}/api/v1/bagilah/guest/${guestToken}${path}`, {
    method: options.method,
    headers: { "Content-Type": "application/json" },
    body: options.body !== undefined ? JSON.stringify(options.body) : undefined,
  });

  if (!response.ok) {
    const error: ApiError = await response
      .json()
      .catch(() => ({ code: "UNKNOWN_ERROR", message: response.statusText }));
    throw new ApiRequestError(response.status, error);
  }
  if (response.status === 204) {
    return undefined as T;
  }
  return response.json() as Promise<T>;
}

export const guestApiClient = {
  get: <T>(guestToken: string, path: string) =>
    guestRequest<T>(guestToken, path, { method: "GET" }),
  post: <T>(guestToken: string, path: string, body?: unknown) =>
    guestRequest<T>(guestToken, path, { method: "POST", body }),
  delete: <T>(guestToken: string, path: string) =>
    guestRequest<T>(guestToken, path, { method: "DELETE" }),
};
