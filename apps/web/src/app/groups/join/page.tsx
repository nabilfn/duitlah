import { Suspense } from "react";
import { JoinStatus } from "./join-status";

export default function JoinGroupPage() {
  return (
    <Suspense>
      <JoinStatus />
    </Suspense>
  );
}
