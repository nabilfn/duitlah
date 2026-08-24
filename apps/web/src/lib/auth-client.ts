import { apiClient } from "./api-client";
import { useAuthStore } from "@/stores/auth-store";
import type { User } from "@/types/user";

interface AuthTokenResponse {
  accessToken: string;
  user: User;
}

export async function login(email: string, password: string): Promise<User> {
  const res = await apiClient.post<AuthTokenResponse>(
    "/api/v1/auth/login",
    { email, password },
    { skipAuth: true },
  );
  useAuthStore.getState().setSession(res.accessToken, res.user);
  return res.user;
}

export async function register(
  email: string,
  password: string,
  displayName: string,
): Promise<User> {
  const res = await apiClient.post<AuthTokenResponse>(
    "/api/v1/auth/register",
    { email, password, displayName },
    { skipAuth: true },
  );
  useAuthStore.getState().setSession(res.accessToken, res.user);
  return res.user;
}

export async function logout(): Promise<void> {
  await apiClient.post("/api/v1/auth/logout", undefined, { skipAuth: true }).catch(() => {});
  useAuthStore.getState().clearSession();
}

export async function logoutAllDevices(): Promise<void> {
  await apiClient.post("/api/v1/auth/logout-all");
  useAuthStore.getState().clearSession();
}

/** Called once on app start: trades the httpOnly refresh cookie (if any) for a fresh access token + user. */
export async function bootstrapSession(): Promise<void> {
  try {
    const { accessToken } = await apiClient.post<{ accessToken: string }>(
      "/api/v1/auth/refresh",
      undefined,
      { skipAuth: true },
    );
    useAuthStore.getState().setAccessToken(accessToken);
    const user = await apiClient.get<User>("/api/v1/users/me");
    useAuthStore.getState().setSession(accessToken, user);
  } catch {
    useAuthStore.getState().setUnauthenticated();
  }
}

export async function requestPasswordReset(email: string): Promise<void> {
  await apiClient.post("/api/v1/auth/password-reset/request", { email }, { skipAuth: true });
}

export async function confirmPasswordReset(token: string, newPassword: string): Promise<void> {
  await apiClient.post(
    "/api/v1/auth/password-reset/confirm",
    { token, newPassword },
    { skipAuth: true },
  );
}

export async function verifyEmail(token: string): Promise<void> {
  await apiClient.post("/api/v1/auth/verify-email", { token }, { skipAuth: true });
}

export async function resendVerificationEmail(): Promise<void> {
  await apiClient.post("/api/v1/auth/verify-email/resend");
}
