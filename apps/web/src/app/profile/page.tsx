"use client";

import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { useAuthStore } from "@/stores/auth-store";
import { ChangePasswordForm } from "./change-password-form";
import { ProfileForm } from "./profile-form";
import { SessionsCard } from "./sessions-card";

export default function ProfilePage() {
  const user = useAuthStore((state) => state.user);

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          <h1 className="text-2xl font-semibold tracking-tight">Settings</h1>
          {user && (
            <>
              <ProfileForm user={user} />
              <ChangePasswordForm />
              <SessionsCard />
            </>
          )}
        </div>
      </AppShell>
    </RequireAuth>
  );
}
