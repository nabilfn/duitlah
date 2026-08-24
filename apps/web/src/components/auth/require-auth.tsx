"use client";

import { useRouter } from "next/navigation";
import { useEffect } from "react";
import { useAuthStore } from "@/stores/auth-store";

/**
 * Client-side route gate. This is UX only, not the security boundary —
 * every protected API call is authorized server-side regardless (see
 * docs/security.md); this just avoids flashing protected content or
 * leaving a signed-out user stranded on a page that will only 401.
 */
function RequireAuth({ children }: { children: React.ReactNode }) {
  const status = useAuthStore((state) => state.status);
  const router = useRouter();

  useEffect(() => {
    if (status === "unauthenticated") {
      router.replace("/login");
    }
  }, [status, router]);

  if (status !== "authenticated") {
    return (
      <div className="flex min-h-dvh items-center justify-center">
        <div className="text-muted-foreground text-sm">Loading…</div>
      </div>
    );
  }

  return children;
}

export { RequireAuth };
