export const metadata = { title: "Terms of Service — Duitlah" };

export default function TermsPage() {
  return (
    <div className="mx-auto max-w-2xl px-4 py-16 md:px-8">
      <h1 className="text-3xl font-semibold tracking-tight">Terms of Service</h1>
      <p className="text-muted-foreground mt-2 text-sm">Last updated 22 August 2026.</p>

      <div className="prose prose-neutral dark:prose-invert mt-8 max-w-none space-y-6 text-sm leading-relaxed">
        <section>
          <h2 className="text-lg font-semibold">What Duitlah is</h2>
          <p className="text-muted-foreground mt-2">
            Duitlah is a personal and shared finance tracker. Its flagship feature, Bagilah, helps
            a group split a bill and work out an exact settlement. Duitlah does not hold, custody,
            or transmit real money on your behalf, and is not a bank, e-wallet, or payment
            processor. Every balance you see is a record of who owes whom based on what you and
            the people you share a group or bill with have entered — settling up still happens
            outside the app, the way it always has.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">Your account</h2>
          <p className="text-muted-foreground mt-2">
            You're responsible for keeping your password confidential and for anything that
            happens under your account. Tell us right away if you think someone else has access to
            it. You must be old enough to enter into an agreement like this one under the laws of
            where you live.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">Accuracy of shared data</h2>
          <p className="text-muted-foreground mt-2">
            Bagilah and Groups rely on the honesty of the people using them — Duitlah computes an
            exact split from what's entered, but has no way to independently verify that a
            real-world payment actually happened. Settlement records are self-reported by whoever
            marks a payment as made; Duitlah is a ledger, not a guarantee.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">Plans</h2>
          <p className="text-muted-foreground mt-2">
            Duitlah Free covers real day-to-day use, including Bagilah, at no cost. Duitlah+ removes
            the free-tier limits on owned groups and receipt scans. We'll always tell you plainly
            what a limit is and what upgrading changes — never a limit designed to make free use
            impractical.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">Acceptable use</h2>
          <p className="text-muted-foreground mt-2">
            Don't use Duitlah to defraud anyone, to misrepresent a debt that doesn't exist, or to
            attempt to access another person's account or data you weren't given access to.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">Changes</h2>
          <p className="text-muted-foreground mt-2">
            We may update these terms as the product changes. Material changes will be reflected
            here with an updated date.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">Contact</h2>
          <p className="text-muted-foreground mt-2">
            Questions about these terms:{" "}
            <a href="mailto:support@duitlah.app" className="underline">
              support@duitlah.app
            </a>
            .
          </p>
        </section>
      </div>
    </div>
  );
}
