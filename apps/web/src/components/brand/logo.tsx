import { cn } from "@/lib/utils";

/**
 * Placeholder brand mark for Phase 1. Two overlapping rounded shapes stand
 * in for "splitting a bill between people" — replace with the final
 * identity when one exists, but keep the two-shape motif if it survives:
 * it's the one visual idea tied directly to Bagilah rather than to fintech
 * iconography in general (coins, wallets, upward arrows).
 */
function LogoMark({ className }: { className?: string }) {
  return (
    <svg viewBox="0 0 32 32" fill="none" className={cn("size-6", className)} aria-hidden="true">
      <rect width="32" height="32" rx="9" className="fill-primary" />
      <circle cx="13" cy="16" r="7" className="fill-primary-foreground" opacity="0.55" />
      <circle cx="19" cy="16" r="7" className="fill-primary-foreground" />
    </svg>
  );
}

function Logo({
  className,
  markClassName,
  iconOnly = false,
}: {
  className?: string;
  markClassName?: string;
  iconOnly?: boolean;
}) {
  return (
    <span className={cn("inline-flex items-center gap-2", className)}>
      <LogoMark className={markClassName} />
      {!iconOnly && (
        <span className="font-heading text-lg leading-none font-semibold tracking-tight">
          Duitlah
        </span>
      )}
    </span>
  );
}

export { Logo, LogoMark };
