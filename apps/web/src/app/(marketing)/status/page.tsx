"use client";

import { useEffect, useState } from "react";
import { CheckCircle2Icon, XCircleIcon, LoaderCircleIcon } from "lucide-react";

type State = "loading" | "up" | "down";

const API_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8080";

/**
 * A real, live check against the API's own `/actuator/health` — not a static "all systems
 * operational" page. `show-details` is `when-authorized` server-side (see application.yml), so an
 * anonymous visitor only ever gets the overall status, never a per-component breakdown; this page
 * shows exactly that and nothing it can't actually verify.
 */
export default function StatusPage() {
  const [state, setState] = useState<State>("loading");
  const [checkedAt, setCheckedAt] = useState<Date | null>(null);

  useEffect(() => {
    let cancelled = false;
    async function check() {
      try {
        const res = await fetch(`${API_URL}/actuator/health`, { cache: "no-store" });
        const body = (await res.json()) as { status?: string };
        if (!cancelled) {
          setState(res.ok && body.status === "UP" ? "up" : "down");
          setCheckedAt(new Date());
        }
      } catch {
        if (!cancelled) {
          setState("down");
          setCheckedAt(new Date());
        }
      }
    }
    check();
    const interval = setInterval(check, 30_000);
    return () => {
      cancelled = true;
      clearInterval(interval);
    };
  }, []);

  return (
    <div className="mx-auto max-w-xl px-4 py-16 md:px-8">
      <h1 className="text-3xl font-semibold tracking-tight">Status</h1>
      <p className="text-muted-foreground mt-3">
        Live check against the Duitlah API, refreshed every 30 seconds.
      </p>

      <div className="mt-8 flex items-center gap-4 rounded-xl border bg-card p-6">
        {state === "loading" && (
          <LoaderCircleIcon className="text-muted-foreground size-8 shrink-0 animate-spin" />
        )}
        {state === "up" && <CheckCircle2Icon className="text-success size-8 shrink-0" />}
        {state === "down" && <XCircleIcon className="text-destructive size-8 shrink-0" />}
        <div>
          <p className="font-medium">
            {state === "loading" && "Checking API status…"}
            {state === "up" && "All systems operational"}
            {state === "down" && "The API is not responding"}
          </p>
          {checkedAt && (
            <p className="text-muted-foreground text-sm">
              Last checked {checkedAt.toLocaleTimeString()}
            </p>
          )}
        </div>
      </div>

      <p className="text-muted-foreground mt-6 text-sm">
        Ongoing issues?{" "}
        <a href="mailto:support@duitlah.app" className="underline">
          Contact support
        </a>
        .
      </p>
    </div>
  );
}
