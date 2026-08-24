import Link from "next/link";

export const metadata = { title: "Privacy Policy — Duitlah" };

export default function PrivacyPage() {
  return (
    <div className="mx-auto max-w-2xl px-4 py-16 md:px-8">
      <h1 className="text-3xl font-semibold tracking-tight">Privacy Policy</h1>
      <p className="text-muted-foreground mt-2 text-sm">Last updated 22 August 2026.</p>

      <div className="prose prose-neutral dark:prose-invert mt-8 max-w-none space-y-6 text-sm leading-relaxed">
        <section>
          <h2 className="text-lg font-semibold">What we collect</h2>
          <p className="text-muted-foreground mt-2">
            To run an account, we store your email address, display name, and a hashed (never
            plain-text) password. To run the app itself, we store the financial data you enter
            yourself — accounts, transactions, budgets, and goals — and the shared data created by
            using Bagilah or Groups with other people: bills, receipt items, claims, group
            expenses, and settlements. If you use smart receipt scanning, the photo you upload is
            stored so it can be reviewed later; if you use the AI assistant, the specific question
            you ask and a summary of your own finances needed to answer it are sent to our AI
            provider for that one request, never stored by them beyond what's needed to respond.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">What we never do</h2>
          <p className="text-muted-foreground mt-2">
            We do not sell your data. We do not use your financial information for advertising —
            not ours, not anyone else's. Duitlah never holds or moves real money between accounts;
            it only records who owes whom, so there is no payment or banking data to protect
            beyond what you've told us yourself.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">Who can see what</h2>
          <p className="text-muted-foreground mt-2">
            Your personal accounts, transactions, budgets, and goals are visible only to you.
            Inside a Group or a Bagilah bill, the other members can see the shared expenses,
            items, and balances that group is actually about — never your unrelated personal
            finances. Joining someone else's group never exposes your own data to them beyond
            what that group itself involves.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">Account deletion</h2>
          <p className="text-muted-foreground mt-2">
            You can permanently delete your account at any time from the Duitlah app (Profile →
            Delete account), by confirming your password. This removes your profile and
            everything tied to it — accounts, transactions, budgets, goals, group memberships, and
            sessions. If you currently own a shared group, you'll be asked to archive it or hand
            off ownership first, so deleting your own account never silently deletes a group's
            shared history for everyone else in it.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">Data export</h2>
          <p className="text-muted-foreground mt-2">
            A self-service export isn't available yet. If you'd like a copy of your data, contact{" "}
            <a href="mailto:support@duitlah.app" className="underline">
              support@duitlah.app
            </a>{" "}
            and we'll get it to you.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">Security</h2>
          <p className="text-muted-foreground mt-2">
            Passwords are hashed with bcrypt. Sessions use short-lived access tokens plus a
            rotating refresh token stored in an httpOnly cookie your browser's JavaScript can
            never read. Every request is authorized against the account making it — the same
            check whether you own the data or were only ever invited to see part of it.
          </p>
        </section>

        <section>
          <h2 className="text-lg font-semibold">Questions</h2>
          <p className="text-muted-foreground mt-2">
            Reach us any time at{" "}
            <a href="mailto:support@duitlah.app" className="underline">
              support@duitlah.app
            </a>
            , or see our{" "}
            <Link href="/terms" className="underline">
              Terms of Service
            </Link>
            .
          </p>
        </section>
      </div>
    </div>
  );
}
