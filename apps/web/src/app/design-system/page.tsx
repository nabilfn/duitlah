"use client";

import { ReceiptTextIcon, UsersIcon } from "lucide-react";
import { toast } from "sonner";
import { Logo, LogoMark } from "@/components/brand/logo";
import { AppShell } from "@/components/nav/app-shell";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  Drawer,
  DrawerContent,
  DrawerDescription,
  DrawerFooter,
  DrawerHeader,
  DrawerTitle,
  DrawerTrigger,
} from "@/components/ui/drawer";
import { EmptyState } from "@/components/ui/empty-state";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { AmountInput } from "@/components/finance/amount-input";
import { BalanceCard } from "@/components/finance/balance-card";
import { StatusPill } from "@/components/finance/status-pill";

const SWATCHES = [
  { name: "primary", label: "Primary" },
  { name: "bagilah", label: "Bagilah" },
  { name: "success", label: "Success" },
  { name: "warning", label: "Warning" },
  { name: "info", label: "Info" },
  { name: "destructive", label: "Destructive" },
] as const;

function Section({
  title,
  description,
  children,
}: {
  title: string;
  description?: string;
  children: React.ReactNode;
}) {
  return (
    <section className="space-y-4">
      <div>
        <h2 className="text-xl font-semibold tracking-tight">{title}</h2>
        {description && <p className="text-muted-foreground mt-1 text-sm">{description}</p>}
      </div>
      {children}
    </section>
  );
}

export default function DesignSystemPage() {
  return (
    <AppShell>
      <div className="mx-auto max-w-3xl space-y-12 px-4 py-8 md:px-8 md:py-10">
        <header className="space-y-1">
          <p className="text-muted-foreground text-sm">Phase 1 — Design System</p>
          <h1 className="text-2xl font-semibold tracking-tight">Duitlah design reference</h1>
          <p className="text-muted-foreground max-w-prose text-sm">
            Internal reference for the tokens and components below. Not a product page — see
            docs/DESIGN.md for the decisions behind each section.
          </p>
        </header>

        <Section title="Logo">
          <div className="flex flex-wrap items-center gap-6">
            <Logo />
            <LogoMark className="size-10" />
          </div>
        </Section>

        <Section
          title="Color"
          description="Neutrals are pure with a whisper of the brand hue; primary carries real surface area rather than sitting as a thin accent."
        >
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
            {SWATCHES.map((s) => (
              <div key={s.name} className="space-y-1.5">
                <div
                  className="flex h-16 items-end rounded-lg p-2"
                  style={{
                    backgroundColor: `var(--${s.name})`,
                    color: `var(--${s.name}-foreground)`,
                  }}
                >
                  <span className="text-xs font-medium">Aa</span>
                </div>
                <p className="text-xs font-medium">{s.label}</p>
              </div>
            ))}
          </div>
        </Section>

        <Section title="Typography">
          <div className="space-y-2">
            <h1 className="text-3xl font-semibold tracking-tight">Heading 1 / 30px</h1>
            <h2 className="text-2xl font-semibold tracking-tight">Heading 2 / 24px</h2>
            <h3 className="text-xl font-semibold tracking-tight">Heading 3 / 20px</h3>
            <h4 className="text-base font-semibold">Heading 4 / 16px</h4>
            <p className="text-sm">Body / 14px — the default for most UI text.</p>
            <p className="text-muted-foreground text-sm">Muted body — secondary information.</p>
            <p className="font-amount text-2xl font-semibold">RM 1,248.60</p>
            <p className="text-muted-foreground text-xs">
              Amounts use tabular figures (.font-amount) so digits align in lists.
            </p>
          </div>
        </Section>

        <Section title="Buttons">
          <div className="flex flex-wrap items-center gap-2">
            <Button>Default</Button>
            <Button variant="secondary">Secondary</Button>
            <Button variant="outline">Outline</Button>
            <Button variant="ghost">Ghost</Button>
            <Button variant="destructive">Destructive</Button>
            <Button variant="link">Link</Button>
          </div>
          <div className="flex flex-wrap items-center gap-2">
            <Button size="sm">Small</Button>
            <Button size="default">Default</Button>
            <Button size="lg">Large</Button>
            <Button disabled>Disabled</Button>
          </div>
          <div className="flex flex-wrap items-center gap-2">
            <Button className="bg-bagilah text-bagilah-foreground hover:bg-bagilah/90">
              <ReceiptTextIcon /> Scan Receipt
            </Button>
          </div>
        </Section>

        <Section title="Inputs">
          <div className="grid max-w-sm gap-4">
            <div className="grid gap-1.5">
              <Label htmlFor="ds-name">Name</Label>
              <Input id="ds-name" placeholder="Nabil" />
            </div>
            <div className="grid gap-1.5">
              <Label htmlFor="ds-amount">Amount</Label>
              <AmountInput id="ds-amount" placeholder="0.00" />
            </div>
          </div>
        </Section>

        <Section
          title="Cards"
          description="The hero balance card carries color deliberately; everything else stays a plain, quiet surface."
        >
          <div className="grid gap-4 sm:grid-cols-2">
            <BalanceCard
              label="Available balance"
              amount="4,842.20"
              meta="August spending: RM 2,431 (↓ 7% vs July)"
            />
            <Card>
              <CardHeader>
                <CardTitle>Housemates</CardTitle>
                <CardDescription>4 members · August</CardDescription>
              </CardHeader>
              <CardContent className="flex items-center justify-between">
                <span className="text-muted-foreground text-sm">People owe you</span>
                <span className="font-amount text-sm font-semibold">RM 360.00</span>
              </CardContent>
            </Card>
          </div>
        </Section>

        <Section title="Status">
          <div className="flex flex-wrap items-center gap-2">
            <StatusPill status="paid" />
            <StatusPill status="partial" />
            <StatusPill status="unpaid" />
            <StatusPill status="overdue" />
            <StatusPill status="cancelled" />
            <Badge>Default badge</Badge>
            <Badge variant="secondary">Secondary badge</Badge>
          </div>
        </Section>

        <Section title="Avatar">
          <div className="flex items-center gap-2">
            <Avatar>
              <AvatarFallback>N</AvatarFallback>
            </Avatar>
            <Avatar>
              <AvatarFallback>A</AvatarFallback>
            </Avatar>
          </div>
        </Section>

        <Section title="Modal &amp; drawer">
          <div className="flex flex-wrap gap-2">
            <Dialog>
              <DialogTrigger render={<Button variant="outline" />}>Open dialog</DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Finalize bill?</DialogTitle>
                  <DialogDescription>
                    Once finalized, participants can no longer change their claims.
                  </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                  <Button>Finalize</Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>

            <Drawer>
              <DrawerTrigger render={<Button variant="outline" />}>Open drawer</DrawerTrigger>
              <DrawerContent>
                <DrawerHeader>
                  <DrawerTitle>Split Fries</DrawerTitle>
                  <DrawerDescription>Choose how to share this item.</DrawerDescription>
                </DrawerHeader>
                <DrawerFooter>
                  <Button>Save</Button>
                </DrawerFooter>
              </DrawerContent>
            </Drawer>
          </div>
        </Section>

        <Section title="Toasts">
          <div className="flex flex-wrap gap-2">
            <Button variant="outline" onClick={() => toast.success("Bill finalized")}>
              Success toast
            </Button>
            <Button variant="outline" onClick={() => toast.error("Couldn't reach the server")}>
              Error toast
            </Button>
            <Button variant="outline" onClick={() => toast.info("Ameer joined the bill")}>
              Info toast
            </Button>
          </div>
        </Section>

        <Section title="Empty state">
          <EmptyState
            icon={UsersIcon}
            title="No bills here yet."
            description="Next time makan ramai-ramai, just Bagilah."
            action={<Button size="sm">Split a Bill</Button>}
          />
        </Section>

        <Section title="Skeleton (loading)">
          <div className="space-y-2">
            {Array.from({ length: 3 }).map((_, i) => (
              <div key={i} className="flex items-center gap-3">
                <Skeleton className="size-9 rounded-full" />
                <div className="flex-1 space-y-1.5">
                  <Skeleton className="h-3.5 w-2/5" />
                  <Skeleton className="h-3 w-1/4" />
                </div>
                <Skeleton className="h-3.5 w-14" />
              </div>
            ))}
          </div>
        </Section>

        <Separator />
        <p className="text-muted-foreground pb-8 text-xs">
          This page exists to exercise the design system end to end — delete or gate it behind a
          dev-only flag before public launch.
        </p>
      </div>
    </AppShell>
  );
}
