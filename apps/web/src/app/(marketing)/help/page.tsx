export const metadata = { title: "Help Centre — Duitlah" };

const TOPICS = [
  {
    category: "Getting started",
    items: [
      {
        title: "Setting up your first account",
        body: "From Accounts, add a wallet, bank account, or e-wallet with its opening balance. Every transaction you log ties back to one of these, so your balances stay accurate automatically.",
      },
      {
        title: "Understanding your Home dashboard",
        body: "Home shows your available balance and recent transactions across all accounts at a glance. Tap any transaction to see or edit its details.",
      },
    ],
  },
  {
    category: "Bagilah",
    items: [
      {
        title: "Splitting a bill with Bagilah",
        body: "Scan a receipt or add items by hand, invite the group with a link, and have everyone tap what they had. Bagilah works out an exact split — including tax, service charge, and discounts — reconciled to the cent.",
      },
      {
        title: "Joining a bill you didn't create",
        body: "Tap the invite link someone shares with you. You don't need a Duitlah account to join and claim items as a guest, though creating one lets you track your own history across bills.",
      },
      {
        title: "What happens when a bill is finalized",
        body: "The bill owner finalizes once everyone's claimed their items. Duitlah computes a simplified settlement — the fewest payments needed to clear every debt in the group.",
      },
    ],
  },
  {
    category: "Groups",
    items: [
      {
        title: "Housemate, Couple, and Trip modes",
        body: "Groups adapt to what you're using them for — Housemate mode tracks recurring shared bills, Couple mode separates 'mine, yours, ours,' and Trip mode supports a foreign-currency snapshot alongside the real amount.",
      },
      {
        title: "Free-tier group limits",
        body: "A free account can own up to 3 active groups at once. Groups you've merely joined never count against this — only ones you created and still own.",
      },
    ],
  },
  {
    category: "Duitlah+",
    items: [
      {
        title: "What Duitlah+ removes",
        body: "Duitlah+ removes the free tier's 3-owned-group and 5-scans-per-month limits. Everything else in the app works exactly the same on both plans.",
      },
    ],
  },
  {
    category: "Account & security",
    items: [
      {
        title: "Changing your password",
        body: "From Profile → Change password, enter your current password and a new one. This signs out every other device you're logged into, keeping your current one active.",
      },
      {
        title: "Deleting your account",
        body: "Profile → Delete account permanently removes your data after confirming your password. If you currently own an active group, archive it or hand off ownership first — this protects other members' shared history.",
      },
    ],
  },
];

export default function HelpPage() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-16 md:px-8">
      <h1 className="text-3xl font-semibold tracking-tight">Help Centre</h1>
      <p className="text-muted-foreground mt-3 max-w-xl text-pretty">
        Guides for getting the most out of Duitlah and Bagilah. Can't find what you need?{" "}
        <a href="mailto:support@duitlah.app" className="underline">
          Contact support
        </a>
        .
      </p>

      <div className="mt-10 space-y-10">
        {TOPICS.map((section) => (
          <section key={section.category}>
            <h2 className="text-lg font-semibold">{section.category}</h2>
            <div className="mt-4 space-y-4">
              {section.items.map((item) => (
                <div key={item.title} className="rounded-xl border bg-card p-4">
                  <p className="font-medium">{item.title}</p>
                  <p className="text-muted-foreground mt-1 text-sm text-pretty">{item.body}</p>
                </div>
              ))}
            </div>
          </section>
        ))}
      </div>
    </div>
  );
}
