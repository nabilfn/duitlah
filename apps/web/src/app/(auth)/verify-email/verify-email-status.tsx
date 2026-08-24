"use client";

import { useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import Link from "next/link";
import { ApiRequestError } from "@/lib/api-client";
import { verifyEmail } from "@/lib/auth-client";

type Status = "verifying" | "success" | "error";

export function VerifyEmailStatus() {
  const token = useSearchParams().get("token");
  const [status, setStatus] = useState<Status>(() => (token ? "verifying" : "error"));
  const [message, setMessage] = useState(() =>
    token ? "" : "This verification link is missing its token.",
  );

  useEffect(() => {
    if (!token) {
      return;
    }
    verifyEmail(token)
      .then(() => setStatus("success"))
      .catch((error: unknown) => {
        setStatus("error");
        setMessage(
          error instanceof ApiRequestError
            ? error.error.message
            : "This link is invalid or has expired.",
        );
      });
  }, [token]);

  if (status === "verifying") {
    return <p className="text-muted-foreground text-center text-sm">Verifying your email…</p>;
  }

  if (status === "success") {
    return (
      <div className="space-y-4 text-center">
        <h1 className="text-xl font-semibold tracking-tight">Email verified</h1>
        <p className="text-muted-foreground text-sm">Thanks for confirming your email.</p>
        <Link href="/dashboard" className="text-sm font-medium hover:underline">
          Continue to Duitlah
        </Link>
      </div>
    );
  }

  return (
    <div className="space-y-4 text-center">
      <h1 className="text-xl font-semibold tracking-tight">Verification failed</h1>
      <p className="text-muted-foreground text-sm">{message}</p>
      <Link href="/" className="text-sm font-medium hover:underline">
        Back to Duitlah
      </Link>
    </div>
  );
}
