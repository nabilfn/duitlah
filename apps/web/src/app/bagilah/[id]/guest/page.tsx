"use client";

import { useQuery, useQueryClient } from "@tanstack/react-query";
import { ReceiptTextIcon } from "lucide-react";
import Link from "next/link";
import { use, useEffect, useState } from "react";
import { Logo } from "@/components/brand/logo";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Skeleton } from "@/components/ui/skeleton";
import { guestApiClient } from "@/lib/guest-api-client";
import { loadGuestSession, type GuestSession } from "@/lib/guest-session";
import { formatAmount, formatDate } from "@/lib/format";
import { useBillEvents } from "@/lib/use-bill-events";
import type { Bill, Breakdown, Claim, Participant, ReceiptItem } from "@/types/bagilah";
import { ClaimItemDialog, type ClaimsApi } from "../claim-item-dialog";

function statusVariant(status: Bill["status"]) {
  if (status === "FINALIZED") return "default" as const;
  if (status === "CANCELLED") return "outline" as const;
  return "secondary" as const;
}

export default function GuestBillPage({ params }: { params: Promise<{ id: string }> }) {
  const { id: billId } = use(params);
  const queryClient = useQueryClient();
  const [session, setSession] = useState<GuestSession | null | undefined>(undefined);

  useEffect(() => {
    // sessionStorage is a synchronous external system; deferring the read to a microtask
    // (rather than calling setState directly in the effect body) is what the "subscribe in a
    // callback" pattern the set-state-in-effect rule asks for looks like for a one-shot read.
    queueMicrotask(() => setSession(loadGuestSession(billId)));
  }, [billId]);

  const guestToken = session?.guestToken ?? "";
  const enabled = Boolean(session);

  const { data: bill, isLoading: billLoading } = useQuery({
    queryKey: ["guest-bill", billId],
    queryFn: () => guestApiClient.get<Bill>(guestToken, ""),
    enabled,
  });
  const { data: items } = useQuery({
    queryKey: ["guest-bill-items", billId],
    queryFn: () => guestApiClient.get<ReceiptItem[]>(guestToken, "/items"),
    enabled,
  });
  const { data: participants } = useQuery({
    queryKey: ["guest-bill-participants", billId],
    queryFn: () => guestApiClient.get<Participant[]>(guestToken, "/participants"),
    enabled,
  });
  const { data: breakdown } = useQuery({
    queryKey: ["guest-bill-breakdown", billId],
    queryFn: () => guestApiClient.get<Breakdown>(guestToken, "/breakdown"),
    enabled,
  });

  useBillEvents(enabled ? `/api/v1/bagilah/guest/${guestToken}/events` : null, null, () => {
    queryClient.invalidateQueries({ queryKey: ["guest-bill-items", billId] });
    queryClient.invalidateQueries({ queryKey: ["guest-bill-participants", billId] });
    queryClient.invalidateQueries({ queryKey: ["guest-bill-breakdown", billId] });
  });

  const claimsApi: ClaimsApi = {
    listClaims: (itemId) => guestApiClient.get<Claim[]>(guestToken, `/items/${itemId}/claims`),
    addClaim: (itemId, body) =>
      guestApiClient.post<Claim>(guestToken, `/items/${itemId}/claims`, body),
    equalSplit: (itemId, participantIds) =>
      guestApiClient.post<Claim[]>(guestToken, `/items/${itemId}/claims/equal-split`, {
        participantIds,
      }),
  };

  function onClaimsChanged() {
    queryClient.invalidateQueries({ queryKey: ["guest-bill-breakdown", billId] });
  }

  if (session === null) {
    return (
      <div className="flex min-h-dvh flex-col items-center justify-center gap-6 px-4 py-12 text-center">
        <Link href="/">
          <Logo />
        </Link>
        <p className="text-muted-foreground max-w-sm text-sm">
          Your session for this bill has expired or wasn&apos;t found. Ask whoever shared it with
          you for the invite link again.
        </p>
      </div>
    );
  }

  const canClaim = bill?.status === "DRAFT";

  return (
    <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
      <div className="flex items-center justify-between gap-4">
        <Logo />
        {session && (
          <span className="text-muted-foreground text-sm">Hi, {session.displayName}</span>
        )}
      </div>

      {(billLoading || session === undefined) && <Skeleton className="h-10 w-48" />}

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

      {participants && participants.length > 0 && (
        <div className="flex flex-wrap gap-2">
          {participants.map((p) => (
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
      )}

      <div>
        <h2 className="mb-2 text-sm font-medium">What did you have?</h2>

        {items?.length === 0 && (
          <EmptyState
            icon={ReceiptTextIcon}
            title="No items yet."
            description="Waiting for the bill owner to add items from the receipt."
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
                Some items still need claiming before this bill can be finalized.
              </div>
            )}

            <div className="space-y-2">
              {breakdown.participants.map((p) => (
                <div key={p.participantId} className="flex items-center justify-between text-sm">
                  <span>{p.displayName}</span>
                  <span className="font-amount font-medium">RM {formatAmount(p.finalAmount)}</span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
