"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { HandCoinsIcon } from "lucide-react";
import { useState } from "react";
import { toast } from "sonner";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { AmountInput } from "@/components/finance/amount-input";
import { StatusPill, type SettlementStatus as PillStatus } from "@/components/finance/status-pill";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { EmptyState } from "@/components/ui/empty-state";
import { Label } from "@/components/ui/label";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { formatAmount } from "@/lib/format";
import type {
  CounterpartySummary,
  Settlement,
  SettlementStatus,
  SettlementSummary,
} from "@/types/settlement";

function toPillStatus(status: SettlementStatus): PillStatus {
  switch (status) {
    case "UNPAID":
      return "unpaid";
    case "PARTIALLY_PAID":
      return "partial";
    case "PAID":
      return "paid";
    case "CANCELLED":
      return "cancelled";
    case "DISPUTED":
      // No dedicated "disputed" pill exists — "overdue" is the closest existing
      // "needs attention" treatment, so it's reused rather than adding a new variant.
      return "overdue";
  }
}

function daysLabel(days: number): string {
  if (days <= 0) return "Today";
  if (days === 1) return "1 day";
  return `${days} days`;
}

function CounterpartyRow({ entry }: { entry: CounterpartySummary }) {
  return (
    <div className="flex items-center justify-between text-sm">
      <div className="flex items-center gap-2">
        <Avatar className="size-6">
          <AvatarFallback className="text-xs">{entry.displayName.charAt(0)}</AvatarFallback>
        </Avatar>
        {entry.displayName}
      </div>
      <div className="text-right">
        <p className="font-amount font-medium">RM {formatAmount(entry.netAmount)}</p>
        <p className="text-muted-foreground text-xs">{daysLabel(entry.oldestUnpaidDays)}</p>
      </div>
    </div>
  );
}

function RecordPaymentDialog({ settlement }: { settlement: Settlement }) {
  const [open, setOpen] = useState(false);
  const [amount, setAmount] = useState(settlement.amountRemaining);
  const queryClient = useQueryClient();

  const mutation = useMutation({
    mutationFn: () =>
      apiClient.post<Settlement>(`/api/v1/settlements/${settlement.id}/payments`, { amount }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["settlements"] });
      queryClient.invalidateQueries({ queryKey: ["settlements-summary"] });
      toast.success("Payment recorded.");
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  return (
    <Dialog
      open={open}
      onOpenChange={(next) => {
        setOpen(next);
        if (next) setAmount(settlement.amountRemaining);
      }}
    >
      <DialogTrigger render={<Button size="sm" variant="outline" />}>Mark paid</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>
            {settlement.fromDisplayName} → {settlement.toDisplayName}
          </DialogTitle>
        </DialogHeader>
        <div className="space-y-4">
          <div className="grid gap-1.5">
            <Label htmlFor="amount">Amount paid</Label>
            <AmountInput id="amount" value={amount} onChange={(e) => setAmount(e.target.value)} />
          </div>
          <p className="text-muted-foreground text-xs">{settlement.handoff.instructions}</p>
          <DialogFooter>
            <Button onClick={() => mutation.mutate()} disabled={mutation.isPending || !amount}>
              {mutation.isPending ? "Saving…" : "Confirm payment"}
            </Button>
          </DialogFooter>
        </div>
      </DialogContent>
    </Dialog>
  );
}

function SettlementRow({ settlement }: { settlement: Settlement }) {
  const queryClient = useQueryClient();

  const cancelMutation = useMutation({
    mutationFn: () => apiClient.post<Settlement>(`/api/v1/settlements/${settlement.id}/cancel`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["settlements"] });
      queryClient.invalidateQueries({ queryKey: ["settlements-summary"] });
      toast.success("Settlement cancelled.");
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  const disputeMutation = useMutation({
    mutationFn: () => apiClient.post<Settlement>(`/api/v1/settlements/${settlement.id}/dispute`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["settlements"] });
      toast.success("Marked as disputed.");
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  const isOpen = settlement.status === "UNPAID" || settlement.status === "PARTIALLY_PAID";

  return (
    <Card>
      <CardContent className="space-y-2">
        <div className="flex items-center justify-between">
          <p className="text-sm font-medium">
            {settlement.fromDisplayName} owes {settlement.toDisplayName}
          </p>
          <StatusPill status={toPillStatus(settlement.status)} />
        </div>
        <div className="flex items-center justify-between text-sm">
          <span className="text-muted-foreground text-xs">
            {settlement.sourceType === "BILL" ? "From a Bagilah bill" : "From a group"}
          </span>
          <span className="font-amount font-medium">
            RM {formatAmount(settlement.amountRemaining)}
            {Number(settlement.amountPaid) > 0 && (
              <span className="text-muted-foreground font-sans text-xs">
                {" "}
                of RM {formatAmount(settlement.amount)}
              </span>
            )}
          </span>
        </div>
        {isOpen && (
          <div className="flex justify-end gap-2">
            {settlement.status !== "DISPUTED" && (
              <Button size="sm" variant="ghost" onClick={() => disputeMutation.mutate()}>
                Dispute
              </Button>
            )}
            <Button size="sm" variant="ghost" onClick={() => cancelMutation.mutate()}>
              Cancel
            </Button>
            <RecordPaymentDialog settlement={settlement} />
          </div>
        )}
      </CardContent>
    </Card>
  );
}

export default function SettlementsPage() {
  const { data: summary, isLoading: summaryLoading } = useQuery({
    queryKey: ["settlements-summary"],
    queryFn: () => apiClient.get<SettlementSummary>("/api/v1/settlements/summary"),
  });
  const { data: settlements, isLoading } = useQuery({
    queryKey: ["settlements"],
    queryFn: () => apiClient.get<Settlement[]>("/api/v1/settlements"),
  });

  const openSettlements =
    settlements?.filter(
      (s) => s.status === "UNPAID" || s.status === "PARTIALLY_PAID" || s.status === "DISPUTED",
    ) ?? [];
  const closedSettlements =
    settlements?.filter((s) => s.status === "PAID" || s.status === "CANCELLED") ?? [];

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          <h1 className="text-2xl font-semibold tracking-tight">Settlements</h1>

          {summaryLoading && <Skeleton className="h-32 w-full" />}

          {summary && (
            <div className="grid grid-cols-2 gap-4">
              <Card>
                <CardContent className="space-y-2">
                  <p className="text-muted-foreground text-xs">People owe you</p>
                  <p className="font-amount text-success text-xl font-semibold">
                    RM {formatAmount(summary.totalOwedToMe)}
                  </p>
                  <div className="space-y-2">
                    {summary.owedToMe.map((entry) => (
                      <CounterpartyRow key={entry.userId} entry={entry} />
                    ))}
                  </div>
                </CardContent>
              </Card>
              <Card>
                <CardContent className="space-y-2">
                  <p className="text-muted-foreground text-xs">You owe</p>
                  <p className="font-amount text-destructive text-xl font-semibold">
                    RM {formatAmount(summary.totalIOwe)}
                  </p>
                  <div className="space-y-2">
                    {summary.iOwe.map((entry) => (
                      <CounterpartyRow key={entry.userId} entry={entry} />
                    ))}
                  </div>
                </CardContent>
              </Card>
            </div>
          )}

          <div>
            <h2 className="mb-2 text-sm font-medium">Outstanding</h2>

            {isLoading && (
              <div className="space-y-2">
                {Array.from({ length: 2 }).map((_, i) => (
                  <Skeleton key={i} className="h-20 w-full" />
                ))}
              </div>
            )}

            {openSettlements.length === 0 && !isLoading && (
              <EmptyState
                icon={HandCoinsIcon}
                title="Nothing outstanding."
                description="Settlements from finalized bills and group settle-ups will show up here."
              />
            )}

            <div className="space-y-2">
              {openSettlements.map((s) => (
                <SettlementRow key={s.id} settlement={s} />
              ))}
            </div>
          </div>

          {closedSettlements.length > 0 && (
            <div>
              <h2 className="mb-2 text-sm font-medium">History</h2>
              <div className="space-y-2">
                {closedSettlements.map((s) => (
                  <SettlementRow key={s.id} settlement={s} />
                ))}
              </div>
            </div>
          )}
        </div>
      </AppShell>
    </RequireAuth>
  );
}
