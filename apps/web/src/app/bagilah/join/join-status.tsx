"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation } from "@tanstack/react-query";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { Logo } from "@/components/brand/logo";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { saveGuestSession } from "@/lib/guest-session";
import { useAuthStore } from "@/stores/auth-store";
import type { JoinBillResponse } from "@/types/bagilah";

const guestNameSchema = z.object({
  guestName: z.string().trim().min(1, "Enter your name").max(120),
});
type GuestNameInput = z.infer<typeof guestNameSchema>;

export function BagilahJoinStatus() {
  const token = useSearchParams().get("token");
  const router = useRouter();
  const status = useAuthStore((s) => s.status);
  const accessToken = useAuthStore((s) => s.accessToken);

  const authenticatedJoinMutation = useMutation({
    mutationFn: () => apiClient.post<JoinBillResponse>("/api/v1/bagilah/join", { token }),
    onSuccess: (res) => router.replace(`/bagilah/${res.billId}`),
  });

  const guestJoinMutation = useMutation({
    mutationFn: (values: GuestNameInput) =>
      apiClient.post<JoinBillResponse>(
        "/api/v1/bagilah/join",
        { token, guestName: values.guestName },
        { skipAuth: true },
      ),
    onSuccess: (res) => {
      saveGuestSession({
        billId: res.billId,
        participantId: res.participantId,
        guestToken: res.guestToken!,
        displayName: res.displayName,
      });
      router.replace(`/bagilah/${res.billId}/guest`);
    },
  });

  useEffect(() => {
    if (token && status === "authenticated" && accessToken) {
      authenticatedJoinMutation.mutate();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [token, status, accessToken]);

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<GuestNameInput>({ resolver: zodResolver(guestNameSchema) });

  const joinError = authenticatedJoinMutation.error ?? guestJoinMutation.error;

  return (
    <div className="flex min-h-dvh flex-col items-center justify-center gap-8 px-4 py-12">
      <Link href="/">
        <Logo />
      </Link>
      <div className="w-full max-w-sm space-y-6">
        {!token && (
          <p className="text-muted-foreground text-center text-sm">
            This invite link is missing its token.
          </p>
        )}

        {token && status === "loading" && (
          <p className="text-muted-foreground text-center text-sm">Checking your session…</p>
        )}

        {token && status === "authenticated" && (
          <p className="text-muted-foreground text-center text-sm">Joining bill…</p>
        )}

        {token && status === "unauthenticated" && (
          <div className="space-y-4">
            <div className="space-y-1 text-center">
              <h1 className="text-xl font-semibold tracking-tight">What did you have?</h1>
              <p className="text-muted-foreground text-sm">
                Enter your name to join this bill — no account needed.
              </p>
            </div>
            <form
              onSubmit={handleSubmit((values) => guestJoinMutation.mutate(values))}
              className="space-y-4"
            >
              <div className="grid gap-1.5">
                <Label htmlFor="guestName">Your name</Label>
                <Input id="guestName" placeholder="Syazmir" {...register("guestName")} />
                {errors.guestName && (
                  <p className="text-destructive text-sm">{errors.guestName.message}</p>
                )}
              </div>
              <Button type="submit" className="w-full" disabled={isSubmitting}>
                {isSubmitting ? "Joining…" : "Join bill"}
              </Button>
            </form>
            <p className="text-muted-foreground text-center text-xs">
              Already have a Duitlah account?{" "}
              <Link
                href={`/login?next=${encodeURIComponent(`/bagilah/join?token=${token}`)}`}
                className="underline"
              >
                Log in
              </Link>{" "}
              to join with it instead.
            </p>
          </div>
        )}

        {joinError && (
          <p className="text-destructive text-center text-sm">
            {joinError instanceof ApiRequestError
              ? joinError.error.message
              : "This invite link is invalid or has expired."}
          </p>
        )}
      </div>
    </div>
  );
}
