"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { ReceiptTextIcon } from "lucide-react";
import { useRouter } from "next/navigation";
import { use } from "react";
import { toast } from "sonner";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { formatAmount, formatDate } from "@/lib/format";
import { useBillEvents } from "@/lib/use-bill-events";
import { useAuthStore } from "@/stores/auth-store";
import type {
  Bill,
  BillBalance,
  Breakdown,
  Claim,
  Participant,
  Payment,
  ReceiptItem,
} from "@/types/bagilah";
import { AddItemDialog } from "./add-item-dialog";
import { AddParticipantDialog } from "./add-participant-dialog";
import { ChargesDialog } from "./charges-dialog";
import { ClaimItemDialog, type ClaimsApi } from "./claim-item-dialog";
import { InviteDialog } from "./invite-dialog";
import { RecordPaymentDialog } from "./record-payment-dialog";

function statusVariant(status: Bill["status"]) {
  if (status === "FINALIZED") return "default" as const;
  if (status === "CANCELLED") return "outline" as const;
  return "secondary" as const;
}

export default function BillDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id: billId } = use(params);
  const router = useRouter();
  const queryClient = useQueryClient();
  const currentUserId = useAuthStore((s) => s.user?.id);
  const accessToken = useAuthStore((s) => s.accessToken);

  const { data: bill, isLoading: billLoading } = useQuery({
    queryKey: ["bill", billId],
    queryFn: () => apiClient.get<Bill>(`/api/v1/bills/${billId}`),
  });
  const { data: items } = useQuery({
    queryKey: ["bill-items", billId],
    queryFn: () => apiClient.get<ReceiptItem[]>(`/api/v1/bills/${billId}/items`),
  });
  const { data: participants } = useQuery({
    queryKey: ["bill-participants", billId],
    queryFn: () => apiClient.get<Participant[]>(`/api/v1/bills/${billId}/participants`),
  });
  const { data: breakdown } = useQuery({
    queryKey: ["bill-breakdown", billId],
    queryFn: () => apiClient.get<Breakdown>(`/api/v1/bills/${billId}/breakdown`),
  });
  const { data: payments } = useQuery({
    queryKey: ["bill-payments", billId],
    queryFn: () => apiClient.get<Payment[]>(`/api/v1/bills/${billId}/payments`),
  });
  const { data: balances } = useQuery({
    queryKey: ["bill-balances", billId],
    queryFn: () => apiClient.get<BillBalance[]>(`/api/v1/bills/${billId}/balances`),
    enabled: bill?.status === "FINALIZED",
  });

  const isOwner = bill?.ownerUserId === currentUserId;
  const isParticipant = participants?.some((p) => p.userId === currentUserId) ?? false;
  const isDraft = bill?.status === "DRAFT";
  const canClaim = isDraft && (isOwner || isParticipant);

  useBillEvents(bill ? `/api/v1/bills/${billId}/events` : null, accessToken, () => {
    queryClient.invalidateQueries({ queryKey: ["bill-items", billId] });
    queryClient.invalidateQueries({ queryKey: ["bill-participants", billId] });
    queryClient.invalidateQueries({ queryKey: ["bill-breakdown", billId] });
    queryClient.invalidateQueries({ queryKey: ["bill-payments", billId] });
  });

  const claimsApi: ClaimsApi = {
    listClaims: (itemId) =>
      apiClient.get<Claim[]>(`/api/v1/bills/${billId}/items/${itemId}/claims`),
    addClaim: (itemId, body) =>
      apiClient.post<Claim>(`/api/v1/bills/${billId}/items/${itemId}/claims`, body),
    equalSplit: (itemId, participantIds) =>
      apiClient.post<Claim[]>(`/api/v1/bills/${billId}/items/${itemId}/claims/equal-split`, {
        participantIds,
      }),
  };

  function onClaimsChanged() {
    queryClient.invalidateQueries({ queryKey: ["bill-breakdown", billId] });
  }

  const finalizeMutation = useMutation({
    mutationFn: () => apiClient.post<Bill>(`/api/v1/bills/${billId}/finalize`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["bill", billId] });
      queryClient.invalidateQueries({ queryKey: ["bill-breakdown", billId] });
      queryClient.invalidateQueries({ queryKey: ["bill-balances", billId] });
      toast.success("Bill finalized.");
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  const cancelMutation = useMutation({
    mutationFn: () => apiClient.delete(`/api/v1/bills/${billId}`),
    onSuccess: () => {
      toast.success("Bill cancelled.");
      router.push("/bagilah");
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  const paymentsByParticipant = new Map((payments ?? []).map((p) => [p.participantId, p]));

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          {billLoading && <Skeleton className="h-10 w-48" />}

          {bill && (
            <div className="flex items-start justify-between gap-4">
              <div>
                <h1 className="text-2xl font-semibold tracking-tight">
                  {bill.merchant || "Untitled bill"}
                </h1>
                <p className="text-muted-foreground text-sm">{formatDate(bill.receiptDate)}</p>
              </div>
              <div className="flex flex-col items-end gap-2">
                <Badge variant={statusVariant(bill.status)}>{bill.status}</Badge>
                {bill.total && (
                  <span className="font-amount text-lg font-semibold">
                    RM {formatAmount(bill.total)}
                  </span>
                )}
              </div>
            </div>
          )}

          {isOwner && isDraft && (
            <div className="flex flex-wrap gap-2">
              <InviteDialog billId={billId} />
              <ChargesDialog bill={bill!} />
              <Button
                size="sm"
                onClick={() => finalizeMutation.mutate()}
                disabled={finalizeMutation.isPending}
              >
                {finalizeMutation.isPending ? "Finalizing…" : "Finalize"}
              </Button>
              <Button
                size="sm"
                variant="destructive"
                onClick={() => cancelMutation.mutate()}
                disabled={cancelMutation.isPending}
              >
                Cancel bill
              </Button>
            </div>
          )}

          <div>
            <div className="mb-2 flex items-center justify-between">
              <h2 className="text-sm font-medium">Participants</h2>
              {isOwner && isDraft && (
                <AddParticipantDialog
                  billId={billId}
                  groupId={bill?.groupId ?? null}
                  existingParticipants={participants ?? []}
                />
              )}
            </div>
            <div className="flex flex-wrap gap-2">
              {participants?.map((p) => (
                <div
                  key={p.id}
                  className="bg-muted flex items-center gap-2 rounded-full py-1 pr-3 pl-1 text-sm"
                >
                  <Avatar className="size-6">
                    <AvatarFallback className="text-xs">{p.displayName.charAt(0)}</AvatarFallback>
                  </Avatar>
                  {p.displayName}
                  {p.guest && <span className="text-muted-foreground text-xs">(guest)</span>}
                </div>
              ))}
            </div>
          </div>

          <div>
            <div className="mb-2 flex items-center justify-between">
              <h2 className="text-sm font-medium">Items</h2>
              {isOwner && isDraft && <AddItemDialog billId={billId} />}
            </div>

            {items?.length === 0 && (
              <EmptyState
                icon={ReceiptTextIcon}
                title="No items yet."
                description="Add what was on the receipt so it can be split."
              />
            )}

            <div className="space-y-2">
              {items?.map((item) => (
                <Card key={item.id}>
                  <CardContent className="flex items-center justify-between">
                    <div>
                      <p className="text-sm font-medium">
                        {item.name} {Number(item.quantity) !== 1 && `× ${item.quantity}`}
                      </p>
                      <p className="text-muted-foreground text-xs">
                        RM {formatAmount(item.totalPrice)}
                        {Number(item.itemDiscount) > 0 &&
                          ` (RM ${formatAmount(item.itemDiscount)} discount applied)`}
                      </p>
                    </div>
                    {canClaim && participants && (
                      <ClaimItemDialog
                        item={item}
                        participants={participants}
                        api={claimsApi}
                        onChanged={onClaimsChanged}
                      />
                    )}
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>

          {breakdown && (
            <Card>
              <CardContent className="space-y-3">
                <p className="text-sm font-medium">Breakdown</p>

                {!breakdown.valid && (
                  <div className="bg-warning/10 text-warning-foreground rounded-md p-2 text-xs">
                    {breakdown.issues.length} item{breakdown.issues.length === 1 ? "" : "s"} still
                    need{breakdown.issues.length === 1 ? "s" : ""} claiming before this bill can be
                    finalized:{" "}
                    {breakdown.issues
                      .map((i) => `${i.itemName} (${i.type.toLowerCase().replace("_", " ")})`)
                      .join(", ")}
                    .
                  </div>
                )}

                <div className="space-y-2">
                  {breakdown.participants.map((p) => (
                    <div
                      key={p.participantId}
                      className="flex items-center justify-between text-sm"
                    >
                      <span>{p.displayName}</span>
                      <span className="font-amount font-medium">
                        RM {formatAmount(p.finalAmount)}
                      </span>
                    </div>
                  ))}
                </div>

                <div className="text-muted-foreground flex items-center justify-between border-t pt-2 text-xs">
                  <span>Subtotal RM {formatAmount(breakdown.subtotal)}</span>
                  <span>
                    Total RM {formatAmount(breakdown.computedTotal)}
                    {Number(breakdown.roundingAdjustment) !== 0 &&
                      ` (rounding ${Number(breakdown.roundingAdjustment) > 0 ? "+" : ""}${breakdown.roundingAdjustment})`}
                  </span>
                </div>
              </CardContent>
            </Card>
          )}

          {isOwner && isDraft && participants && participants.length > 0 && (
            <div>
              <h2 className="mb-2 text-sm font-medium">Who paid?</h2>
              <div className="space-y-2">
                {participants.map((p) => {
                  const payment = paymentsByParticipant.get(p.id);
                  return (
                    <div key={p.id} className="flex items-center justify-between text-sm">
                      <span>{p.displayName}</span>
                      <div className="flex items-center gap-2">
                        {payment && (
                          <span className="font-amount">RM {formatAmount(payment.amountPaid)}</span>
                        )}
                        <RecordPaymentDialog
                          billId={billId}
                          participant={p}
                          existingAmount={payment?.amountPaid}
                        />
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {bill?.status === "FINALIZED" && balances && (
            <Card>
              <CardContent className="space-y-2">
                <p className="text-sm font-medium">Balances</p>
                {balances.map((b) => (
                  <div key={b.participantId} className="flex items-center justify-between text-sm">
                    <span>{b.displayName}</span>
                    <span
                      className={
                        Number(b.net) > 0
                          ? "text-success"
                          : Number(b.net) < 0
                            ? "text-destructive"
                            : ""
                      }
                    >
                      {Number(b.net) > 0
                        ? `Owed RM ${formatAmount(b.net)}`
                        : Number(b.net) < 0
                          ? `Owes RM ${formatAmount(Math.abs(Number(b.net)))}`
                          : "Settled up"}
                    </span>
                  </div>
                ))}
              </CardContent>
            </Card>
          )}
        </div>
      </AppShell>
    </RequireAuth>
  );
}
