import { cn } from "@/lib/utils";

/**
 * Text input for entering an amount of money. Renders as a plain
 * `type="text" inputMode="decimal"` field rather than `type="number"` —
 * number inputs allow scientific notation and scroll-to-change, both wrong
 * for currency, and their spinner UI has no use here.
 *
 * Formatting/parsing (thousands separators, clamping to 2dp) is the
 * caller's job — this component owns presentation only, matching every
 * other shadcn form primitive in this project.
 */
function AmountInput({
  className,
  currency = "RM",
  ...props
}: React.ComponentProps<"input"> & { currency?: string }) {
  return (
    <div
      className={cn(
        "border-input has-[input:focus-visible]:border-ring has-[input:focus-visible]:ring-ring/50 flex h-9 items-center gap-1.5 rounded-md border bg-transparent px-3 shadow-xs transition-[color,box-shadow] has-[input:focus-visible]:ring-3",
        className,
      )}
    >
      <span className="text-muted-foreground text-sm select-none">{currency}</span>
      <input
        type="text"
        inputMode="decimal"
        data-slot="amount-input"
        className="font-amount placeholder:text-muted-foreground w-full bg-transparent text-sm outline-none disabled:cursor-not-allowed disabled:opacity-50"
        {...props}
      />
    </div>
  );
}

export { AmountInput };
