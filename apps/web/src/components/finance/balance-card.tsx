import { cn } from "@/lib/utils";

/**
 * The hero money display: a solid, confident primary-color surface, not
 * another white card with a shadow. Reserve this treatment for the one or
 * two numbers per screen that matter most (available balance, a bill's
 * total) — everything else (transaction rows, settings) stays on plain
 * surfaces. If every card looks like this, none of them do.
 */
function BalanceCard({
  label,
  amount,
  currency = "RM",
  meta,
  className,
}: {
  label: string;
  amount: string;
  currency?: string;
  meta?: React.ReactNode;
  className?: string;
}) {
  return (
    <div
      className={cn(
        "bg-primary text-primary-foreground relative overflow-hidden rounded-2xl px-5 py-6",
        className,
      )}
    >
      <p className="text-primary-foreground/75 text-sm font-medium">{label}</p>
      <p className="font-amount mt-1.5 text-4xl font-semibold tracking-tight">
        <span className="text-primary-foreground/75 mr-1 align-top text-xl">{currency}</span>
        {amount}
      </p>
      {meta && <div className="text-primary-foreground/85 mt-3 text-sm">{meta}</div>}
    </div>
  );
}

export { BalanceCard };
