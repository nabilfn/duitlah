"use client";

import { useMutation } from "@tanstack/react-query";
import { useRouter, useSearchParams } from "next/navigation";
import { useEffect } from "react";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import type { Group } from "@/types/group";

export function JoinStatus() {
  const token = useSearchParams().get("token");
  const router = useRouter();

  const joinMutation = useMutation({
    mutationFn: () => apiClient.post<Group>("/api/v1/groups/join", { token }),
    onSuccess: (group) => router.replace(`/groups/${group.id}`),
  });

  useEffect(() => {
    if (token) joinMutation.mutate();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [token]);

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-sm space-y-2 px-4 py-16 text-center">
          {!token && (
            <p className="text-muted-foreground text-sm">This invite link is missing its token.</p>
          )}
          {token && joinMutation.isPending && (
            <p className="text-muted-foreground text-sm">Joining group…</p>
          )}
          {token && joinMutation.isError && (
            <p className="text-destructive text-sm">
              {joinMutation.error instanceof ApiRequestError
                ? joinMutation.error.error.message
                : "This invite link is invalid or has expired."}
            </p>
          )}
        </div>
      </AppShell>
    </RequireAuth>
  );
}
