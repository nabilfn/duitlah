import Link from "next/link";
import { CheckIcon, ReceiptTextIcon, ScanLineIcon, SplitIcon } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";

/**
 * Public marketing home (Phase 15: Public Launch). Everything an authenticated
 * user actually does lives at /dashboard now — this route is the one a
 * logged-out visitor (or a search engine) actually lands on, so it has to
 * stand on its own without ever assuming a session exists.
 */
export default function LandingPage() {
  return (
    <>
      {/* Hero */}
        <section className="mx-auto max-w-6xl px-4 pt-16 pb-20 md:px-8 md:pt-24 md:pb-28">
          <div className="mx-auto max-w-2xl text-center">
            <Badge variant="secondary" className="mb-5">
              Built for Malaysia
            </Badge>
            <h1 className="text-4xl font-semibold tracking-tight text-balance md:text-6xl">
              Money made social.
            </h1>
            <p className="text-muted-foreground mt-5 text-lg text-pretty md:text-xl">
              Track your own money, split bills down to the cent with Bagilah, and settle up with
              the people you actually spend life with — one app, one running total.
            </p>
            <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row">
              <Button size="lg" nativeButton={false} render={<Link href="/register">Get started free</Link>} />
              <Button
                size="lg"
                variant="outline"
                nativeButton={false}
                render={<a href="#bagilah">See how Bagilah works</a>}
              />
            </div>
            <p className="text-muted-foreground mt-4 text-xs">
              Free forever for personal finance. No card required.
            </p>
          </div>
        </section>

        {/* Bagilah */}
        <section id="bagilah" className="border-border/60 border-t bg-muted/30">
          <div className="mx-auto max-w-6xl px-4 py-16 md:px-8 md:py-24">
            <div className="grid gap-12 md:grid-cols-2 md:items-center md:gap-16">
              <div>
                <span className="text-bagilah text-sm font-semibold tracking-wide">
                  Bagilah — our flagship feature
                </span>
                <h2 className="mt-2 text-3xl font-semibold tracking-tight text-balance">
                  Scan. Claim. Settle.
                </h2>
                <p className="text-muted-foreground mt-4 text-pretty">
                  Snap a photo of the receipt. Everyone taps what they actually had. Bagilah works
                  out an exact split — tax, service charge, and discounts allocated fairly,
                  reconciled to the cent against the real total. No more "let's just each pay
                  RM40."
                </p>
                <Button
                  variant="link"
                  className="mt-2 h-auto px-0"
                  nativeButton={false}
                  render={<Link href="/register">Try Bagilah free →</Link>}
                />
              </div>

              <ol className="space-y-4">
                {[
                  {
                    icon: ScanLineIcon,
                    title: "Scan the receipt",
                    body: "Photograph it, or add items by hand — either way, everyone in the group sees the same bill.",
                  },
                  {
                    icon: SplitIcon,
                    title: "Everyone claims their items",
                    body: "Each person taps what they had. Shared items split evenly among whoever claims them.",
                  },
                  {
                    icon: CheckIcon,
                    title: "Get an exact settlement",
                    body: "Bagilah calculates who owes whom, down to the cent — no rounding arguments.",
                  },
                ].map((step, index) => (
                  <li key={step.title} className="flex gap-4 rounded-xl border bg-card p-4">
                    <div className="bg-bagilah/15 text-bagilah flex size-10 shrink-0 items-center justify-center rounded-full font-semibold">
                      {index + 1}
                    </div>
                    <div>
                      <p className="flex items-center gap-2 font-medium">
                        <step.icon className="text-bagilah size-4" />
                        {step.title}
                      </p>
                      <p className="text-muted-foreground mt-1 text-sm text-pretty">
                        {step.body}
                      </p>
                    </div>
                  </li>
                ))}
              </ol>
            </div>
          </div>
        </section>

        {/* Personal finance + groups */}
        <section className="border-border/60 border-t">
          <div className="mx-auto max-w-6xl px-4 py-16 md:px-8 md:py-24">
            <div className="grid gap-12 md:grid-cols-[1.1fr_1fr] md:gap-16">
              <div>
                <h2 className="text-3xl font-semibold tracking-tight text-balance">
                  One home for your money — and everyone else&apos;s you share it with.
                </h2>
                <p className="text-muted-foreground mt-4 max-w-md text-pretty">
                  Duitlah isn&apos;t just Bagilah. It&apos;s where your accounts, budgets, and
                  goals live day to day, and where a household, a couple, or a trip keeps a shared
                  running balance without anyone chasing anyone over text.
                </p>
              </div>
              <ul className="grid grid-cols-1 gap-x-8 gap-y-3 text-sm sm:grid-cols-2">
                {[
                  "Accounts, transactions & categories",
                  "Budgets that track what you've actually spent",
                  "Savings goals, personal or shared",
                  "Groups for housemates, couples, and trips",
                  "Recurring transactions & subscription tracking",
                  "A financial calendar and cash-flow forecast",
                  "Smart receipt scanning",
                  "An AI assistant for affordability checks",
                ].map((item) => (
                  <li key={item} className="flex items-start gap-2">
                    <CheckIcon className="text-primary mt-0.5 size-4 shrink-0" />
                    <span className="text-pretty">{item}</span>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </section>

        {/* Trust */}
        <section className="border-border/60 border-t bg-muted/30">
          <div className="mx-auto max-w-6xl px-4 py-16 md:px-8 md:py-20">
            <h2 className="text-2xl font-semibold tracking-tight">
              We never hold your money.
            </h2>
            <p className="text-muted-foreground mt-3 max-w-2xl text-pretty">
              Duitlah records what people owe each other — it never moves real funds between
              accounts. Settling up still happens the way it always has (bank transfer, cash,
              e-wallet); Duitlah just keeps everyone honest about the number.
            </p>
            <ul className="text-muted-foreground mt-6 grid grid-cols-1 gap-3 text-sm sm:grid-cols-3">
              <li className="flex items-start gap-2">
                <CheckIcon className="text-primary mt-0.5 size-4 shrink-0" />
                Passwords are hashed, never stored in plain text.
              </li>
              <li className="flex items-start gap-2">
                <CheckIcon className="text-primary mt-0.5 size-4 shrink-0" />
                Short-lived sessions with automatic rotation.
              </li>
              <li className="flex items-start gap-2">
                <CheckIcon className="text-primary mt-0.5 size-4 shrink-0" />
                Every write is scoped to accounts and groups you actually belong to.
              </li>
            </ul>
          </div>
        </section>

        {/* Pricing */}
        <section className="border-border/60 border-t">
          <div className="mx-auto max-w-6xl px-4 py-16 md:px-8 md:py-24">
            <div className="mx-auto max-w-xl text-center">
              <h2 className="text-3xl font-semibold tracking-tight">Simple, honest pricing</h2>
              <p className="text-muted-foreground mt-3 text-pretty">
                Free covers real day-to-day use. Upgrade only if you outgrow it.
              </p>
            </div>
            <div className="mx-auto mt-10 grid max-w-3xl gap-6 sm:grid-cols-2">
              <div className="rounded-2xl border bg-card p-6">
                <p className="font-semibold">Duitlah Free</p>
                <p className="text-muted-foreground mt-1 text-sm">RM0 / month</p>
                <ul className="text-muted-foreground mt-5 space-y-2 text-sm">
                  <li className="flex gap-2">
                    <CheckIcon className="mt-0.5 size-4 shrink-0" /> Unlimited personal finance
                  </li>
                  <li className="flex gap-2">
                    <CheckIcon className="mt-0.5 size-4 shrink-0" /> Up to 3 active groups you own
                  </li>
                  <li className="flex gap-2">
                    <CheckIcon className="mt-0.5 size-4 shrink-0" /> 5 smart receipt scans / month
                  </li>
                  <li className="flex gap-2">
                    <CheckIcon className="mt-0.5 size-4 shrink-0" /> Join unlimited groups owned
                    by others
                  </li>
                </ul>
              </div>
              <div className="border-primary rounded-2xl border-2 bg-card p-6">
                <p className="flex items-center gap-2 font-semibold">
                  Duitlah+ <Badge>Plus</Badge>
                </p>
                <p className="text-muted-foreground mt-1 text-sm">For power users</p>
                <ul className="text-muted-foreground mt-5 space-y-2 text-sm">
                  <li className="flex gap-2">
                    <CheckIcon className="text-primary mt-0.5 size-4 shrink-0" /> Everything in
                    Free
                  </li>
                  <li className="flex gap-2">
                    <CheckIcon className="text-primary mt-0.5 size-4 shrink-0" /> Unlimited owned
                    groups
                  </li>
                  <li className="flex gap-2">
                    <CheckIcon className="text-primary mt-0.5 size-4 shrink-0" /> Unlimited
                    receipt scans
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </section>

        {/* Final CTA */}
        <section className="border-border/60 border-t">
          <div className="mx-auto max-w-6xl px-4 py-16 text-center md:px-8 md:py-24">
            <ReceiptTextIcon className="text-bagilah mx-auto size-10" />
            <h2 className="mt-4 text-3xl font-semibold tracking-tight text-balance">
              Split the next bill in under a minute.
            </h2>
            <div className="mt-6">
              <Button size="lg" nativeButton={false} render={<Link href="/register">Get started free</Link>} />
            </div>
          </div>
        </section>
    </>
  );
}
