import { Suspense } from "react";
import { VerifyEmailStatus } from "./verify-email-status";

export default function VerifyEmailPage() {
  return (
    <Suspense>
      <VerifyEmailStatus />
    </Suspense>
  );
}
