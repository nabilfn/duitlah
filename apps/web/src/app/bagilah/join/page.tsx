import { Suspense } from "react";
import { BagilahJoinStatus } from "./join-status";

export default function BagilahJoinPage() {
  return (
    <Suspense>
      <BagilahJoinStatus />
    </Suspense>
  );
}
