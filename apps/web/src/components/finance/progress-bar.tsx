import { cn } from "@/lib/utils";

/** A plain div-based bar rather than pulling in a new primitive for something this simple. */
function ProgressBar({
  percentage,
  tone = "primary",
}: {
  percentage: number;
  tone?: "primary" | "warning" | "destructive";
}) {
  const clamped = Math.min(100, Math.max(0, percentage));
  return (
    <div className="bg-muted h-2 w-full overflow-hidden rounded-full">
      <div
        className={cn(
          "h-full rounded-full transition-all",
          tone === "destructive" && "bg-destructive",
          tone === "warning" && "bg-warning",
          tone === "primary" && "bg-primary",
        )}
        style={{ width: `${clamped}%` }}
      />
    </div>
  );
}

export { ProgressBar };
