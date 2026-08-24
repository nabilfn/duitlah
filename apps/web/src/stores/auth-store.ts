import { create } from "zustand";
import type { User } from "@/types/user";

type AuthStatus = "loading" | "authenticated" | "unauthenticated";

interface AuthState {
  status: AuthStatus;
  accessToken: string | null;
  user: User | null;
  setSession: (accessToken: string, user: User) => void;
  setAccessToken: (accessToken: string) => void;
  clearSession: () => void;
  setUnauthenticated: () => void;
}

/**
 * The access token lives only here — in memory, never persisted to
 * localStorage/sessionStorage — so it disappears on tab close or reload.
 * That's intentional: the refresh token (httpOnly cookie, invisible to JS)
 * is what survives a reload, and `bootstrapSession` (auth-client.ts) uses
 * it to obtain a fresh access token on app start.
 */
export const useAuthStore = create<AuthState>((set) => ({
  status: "loading",
  accessToken: null,
  user: null,
  setSession: (accessToken, user) => set({ status: "authenticated", accessToken, user }),
  setAccessToken: (accessToken) => set({ accessToken }),
  clearSession: () => set({ status: "unauthenticated", accessToken: null, user: null }),
  setUnauthenticated: () => set({ status: "unauthenticated" }),
}));
