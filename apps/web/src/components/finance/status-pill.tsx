import { CheckIcon, ClockIcon, CircleAlertIcon, CircleDashedIcon, XIcon } from "lucide-react";
import { cn } from "@/lib/utils";

export type SettlementStatus = "paid" | "partial" | "unpaid" | "overdue" | "cancelled";

const STATUS_CONFIG: Record<
  SettlementStatus,
  { label: string; icon: typeof CheckIcon; className: string }
> = {
  paid: {
    label: "Paid",
    icon: CheckIcon,
    className: "bg-success/10 text-success dark:bg-success/15",
  },
  partial: {
    label: "Partially paid",
    icon: CircleDashedIcon,
    className: "bg-info/10 text-info dark:bg-info/15",
  },
  unpaid: {
    label: "Unpaid",
    icon: ClockIcon,
    className: "bg-muted text-muted-foreground",
  },
  overdue: {
    label: "Overdue",
    icon: CircleAlertIcon,
    className: "bg-destructive/10 text-destructive dark:bg-destructive/15",
  },
  cancelled: {
    label: "Cancelled",
    icon: XIcon,
    className: "bg-muted text-muted-foreground line-through",
  },
};

/**
 * Status is never color-only (see PRODUCT.md's accessibility section) —
 * every status pill pairs its color with a distinct icon and label, so it
 * still reads correctly for color-blind users or in grayscale.
 */
function StatusPill({ status, className }: { status: SettlementStatus; className?: string }) {
  const { label, icon: Icon, className: statusClassName } = STATUS_CONFIG[status];
  return (
    <span
      className={cn(
        "inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-xs font-medium",
        statusClassName,
        className,
      )}
    >
      <Icon className="size-3" />
      {label}
    </span>
  );
}

export { StatusPill };
