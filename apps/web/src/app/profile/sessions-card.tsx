"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { LaptopIcon } from "lucide-react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient } from "@/lib/api-client";
import { logout, logoutAllDevices } from "@/lib/auth-client";
import type { Session } from "@/types/session";

export function SessionsCard() {
  const router = useRouter();
  const queryClient = useQueryClient();

  const { data: sessions, isLoading } = useQuery({
    queryKey: ["sessions"],
    queryFn: () => apiClient.get<Session[]>("/api/v1/auth/sessions"),
  });

  const revokeMutation = useMutation({
    mutationFn: (sessionId: string) => apiClient.delete(`/api/v1/auth/sessions/${sessionId}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["sessions"] });
      toast.success("Device signed out.");
    },
  });

  async function handleLogout() {
    await logout();
    router.push("/login");
  }

  async function handleLogoutAll() {
    await logoutAllDevices();
    router.push("/login");
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Devices</CardTitle>
        <CardDescription>Where you&apos;re currently signed in.</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="space-y-2">
          {isLoading &&
            Array.from({ length: 2 }).map((_, i) => <Skeleton key={i} className="h-12 w-full" />)}
          {sessions?.map((session) => (
            <div
              key={session.id}
              className="flex items-center justify-between gap-3 rounded-lg border px-3 py-2"
            >
              <div className="flex items-center gap-2.5 overflow-hidden">
                <LaptopIcon className="text-muted-foreground size-4 shrink-0" />
                <div className="min-w-0">
                  <p className="truncate text-sm">{session.userAgent ?? "Unknown device"}</p>
                  <p className="text-muted-foreground text-xs">
                    Last active {new Date(session.lastUsedAt).toLocaleString()}
                  </p>
                </div>
              </div>
              {session.current ? (
                <Badge variant="secondary">This device</Badge>
              ) : (
                <Button
                  size="sm"
                  variant="outline"
                  disabled={revokeMutation.isPending}
                  onClick={() => revokeMutation.mutate(session.id)}
                >
                  Sign out
                </Button>
              )}
            </div>
          ))}
        </div>

        <div className="flex gap-2 border-t pt-4">
          <Button variant="outline" onClick={handleLogout}>
            Log out
          </Button>
          <Button variant="outline" className="text-destructive" onClick={handleLogoutAll}>
            Log out everywhere
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
