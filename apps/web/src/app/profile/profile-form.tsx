"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useForm } from "react-hook-form";
import { toast } from "sonner";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { resendVerificationEmail } from "@/lib/auth-client";
import { updateProfileSchema, type UpdateProfileInput } from "@/lib/validation/auth";
import { useAuthStore } from "@/stores/auth-store";
import type { User } from "@/types/user";

export function ProfileForm({ user }: { user: User }) {
  const queryClient = useQueryClient();
  const setSession = useAuthStore((state) => state.setSession);
  const accessToken = useAuthStore((state) => state.accessToken);

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting, isDirty },
  } = useForm<UpdateProfileInput>({
    resolver: zodResolver(updateProfileSchema),
    defaultValues: { displayName: user.displayName },
  });

  const resendMutation = useMutation({
    mutationFn: resendVerificationEmail,
    onSuccess: () => toast.success("Verification email sent."),
    onError: () => toast.error("Couldn't send the email. Try again shortly."),
  });

  async function onSubmit(values: UpdateProfileInput) {
    try {
      const updated = await apiClient.patch<User>("/api/v1/users/me", values);
      if (accessToken) setSession(accessToken, updated);
      queryClient.invalidateQueries({ queryKey: ["me"] });
      toast.success("Profile updated.");
    } catch (error) {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    }
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Profile</CardTitle>
        <CardDescription>{user.email}</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        {!user.emailVerified && (
          <div className="bg-warning/10 flex items-center justify-between gap-3 rounded-lg px-3 py-2">
            <span className="text-warning text-sm">Your email isn&apos;t verified yet.</span>
            <Button
              type="button"
              size="sm"
              variant="outline"
              disabled={resendMutation.isPending}
              onClick={() => resendMutation.mutate()}
            >
              Resend
            </Button>
          </div>
        )}
        {user.emailVerified && (
          <Badge variant="secondary" className="bg-success/10 text-success">
            Email verified
          </Badge>
        )}

        <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
          <div className="grid gap-1.5">
            <Label htmlFor="displayName">Name</Label>
            <Input id="displayName" {...register("displayName")} />
            {errors.displayName && (
              <p className="text-destructive text-sm">{errors.displayName.message}</p>
            )}
          </div>
          <Button type="submit" disabled={isSubmitting || !isDirty}>
            {isSubmitting ? "Saving…" : "Save changes"}
          </Button>
        </form>
      </CardContent>
    </Card>
  );
}
