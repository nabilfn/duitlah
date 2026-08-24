export const metadata = { title: "FAQ — Duitlah" };

const FAQS = [
  {
    q: "Does Duitlah hold or move my money?",
    a: "No. Duitlah only records who owes whom — it never touches real funds. Settling up still happens the way it always has (bank transfer, cash, e-wallet); Duitlah just keeps the number honest.",
  },
  {
    q: "What's the difference between Groups and Bagilah?",
    a: "Bagilah is for one-off bills — scan a receipt, everyone claims their items, get an exact split. Groups are ongoing — a household, a couple, or a trip that keeps a running shared balance over time, including its own lightweight expense splitting.",
  },
  {
    q: "Do I need an account to join a Bagilah bill?",
    a: "No. Anyone you share an invite link with can join as a guest and claim their items without creating a Duitlah account. Creating one just means your claims and history carry over between bills.",
  },
  {
    q: "What happens to my data if I downgrade or stay on Free?",
    a: "Nothing is deleted. If you're above a Free-tier limit (for example, you own more than 3 active groups because you upgraded and later downgraded), you won't lose any existing groups — you just can't create new ones until you're back under the limit.",
  },
  {
    q: "Can I delete my account?",
    a: "Yes, any time, from Profile → Delete account, after confirming your password. This permanently removes your data. If you currently own an active shared group, you'll need to archive it or transfer ownership first, so your deletion never silently removes a group's history for everyone else in it.",
  },
  {
    q: "Is the AI assistant's advice reliable?",
    a: "The assistant never invents your numbers — every figure it shows (balances, forecasts, affordability checks) is computed by the same finance engine as the rest of the app, not guessed by the AI. Treat its answers as a helpful estimate, not professional financial advice.",
  },
  {
    q: "What counts against the free receipt-scan limit?",
    a: "Every scan attempt in a calendar month, whether or not it successfully reads the receipt — the limit protects the scanning service itself, not just successful results. You can always add a bill's items by hand at no cost.",
  },
];

export default function FaqPage() {
  return (
    <div className="mx-auto max-w-2xl px-4 py-16 md:px-8">
      <h1 className="text-3xl font-semibold tracking-tight">Frequently asked questions</h1>
      <p className="text-muted-foreground mt-3 text-pretty">
        Don't see your question?{" "}
        <a href="mailto:support@duitlah.app" className="underline">
          Ask us directly
        </a>
        .
      </p>

      <div className="mt-8 divide-y rounded-xl border">
        {FAQS.map((item) => (
          <details key={item.q} className="group p-4 open:bg-muted/30">
            <summary className="flex cursor-pointer list-none items-center justify-between gap-4 font-medium marker:content-none">
              {item.q}
              <span
                aria-hidden
                className="text-muted-foreground shrink-0 transition-transform group-open:rotate-45"
              >
                +
              </span>
            </summary>
            <p className="text-muted-foreground mt-3 text-sm text-pretty">{item.a}</p>
          </details>
        ))}
      </div>
    </div>
  );
}
