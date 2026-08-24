"use client";

import { useMutation, useQuery } from "@tanstack/react-query";
import { useState } from "react";
import { toast } from "sonner";
import { AmountInput } from "@/components/finance/amount-input";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { ApiRequestError } from "@/lib/api-client";
import type { Claim, ClaimType, Participant, ReceiptItem } from "@/types/bagilah";

type Mode = "EQUAL" | "CUSTOM";

/**
 * Injected rather than hardcoded to `apiClient` so this one dialog serves both the
 * owner/participant page (real bearer-token endpoints) and the guest page (guest-token
 * endpoints) without duplicating this UI — see bagilah/[id]/guest/page.tsx.
 */
export interface ClaimsApi {
  listClaims: (itemId: string) => Promise<Claim[]>;
  addClaim: (
    itemId: string,
    body: { participantId: string; claimType: ClaimType; value: string },
  ) => Promise<Claim>;
  equalSplit: (itemId: string, participantIds: string[]) => Promise<Claim[]>;
}

export function ClaimItemDialog({
  item,
  participants,
  api,
  onChanged,
}: {
  item: ReceiptItem;
  participants: Participant[];
  api: ClaimsApi;
  onChanged: () => void;
}) {
  const [open, setOpen] = useState(false);
  const [mode, setMode] = useState<Mode>("EQUAL");
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [claimType, setClaimType] = useState<ClaimType>("PERCENTAGE");
  const [values, setValues] = useState<Record<string, string>>({});

  const { data: existingClaims } = useQuery({
    queryKey: ["item-claims", item.id],
    queryFn: () => api.listClaims(item.id),
    enabled: open,
  });

  const equalSplitMutation = useMutation({
    mutationFn: () => api.equalSplit(item.id, Array.from(selected)),
    onSuccess: () => {
      onChanged();
      toast.success("Split equally.");
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  const customClaimMutation = useMutation({
    mutationFn: async () => {
      const entries = Object.entries(values).filter(([, v]) => v.trim() !== "");
      for (const [participantId, value] of entries) {
        await api.addClaim(item.id, { participantId, claimType, value });
      }
    },
    onSuccess: () => {
      onChanged();
      toast.success("Claims saved.");
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  function toggle(participantId: string) {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(participantId)) next.delete(participantId);
      else next.add(participantId);
      return next;
    });
  }

  return (
    <Dialog
      open={open}
      onOpenChange={(next) => {
        setOpen(next);
        if (next) {
          setSelected(new Set(participants.map((p) => p.id)));
          setValues({});
        }
      }}
    >
      <DialogTrigger render={<Button size="sm" variant="outline" />}>Claim</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Who had {item.name}?</DialogTitle>
        </DialogHeader>

        {existingClaims && existingClaims.length > 0 && (
          <p className="text-muted-foreground text-xs">
            Currently claimed by {existingClaims.map((c) => c.displayName).join(", ")}. Saving again
            replaces these.
          </p>
        )}

        <div className="flex gap-2">
          <Button
            type="button"
            size="sm"
            variant={mode === "EQUAL" ? "default" : "outline"}
            onClick={() => setMode("EQUAL")}
          >
            Split equally
          </Button>
          <Button
            type="button"
            size="sm"
            variant={mode === "CUSTOM" ? "default" : "outline"}
            onClick={() => setMode("CUSTOM")}
          >
            Custom split
          </Button>
        </div>

        {mode === "EQUAL" && (
          <div className="space-y-4">
            <div className="space-y-2">
              {participants.map((p) => (
                <label key={p.id} className="flex items-center gap-2 text-sm">
                  <Checkbox checked={selected.has(p.id)} onCheckedChange={() => toggle(p.id)} />
                  {p.displayName}
                </label>
              ))}
            </div>
            <DialogFooter>
              <Button
                onClick={() => equalSplitMutation.mutate()}
                disabled={equalSplitMutation.isPending || selected.size === 0}
              >
                {equalSplitMutation.isPending ? "Saving…" : `Split RM ${item.totalPrice} equally`}
              </Button>
            </DialogFooter>
          </div>
        )}

        {mode === "CUSTOM" && (
          <div className="space-y-4">
            <div className="grid gap-1.5">
              <Label htmlFor="claimType">Split by</Label>
              <Select value={claimType} onValueChange={(v) => setClaimType(v as ClaimType)}>
                <SelectTrigger id="claimType" className="w-full">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="PERCENTAGE">Percentage (must total 100%)</SelectItem>
                  <SelectItem value="QUANTITY">Quantity (must total {item.quantity})</SelectItem>
                  <SelectItem value="AMOUNT">
                    RM amount (must total RM {item.totalPrice})
                  </SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              {participants.map((p) => (
                <div key={p.id} className="flex items-center justify-between gap-2">
                  <Label className="text-sm font-normal">{p.displayName}</Label>
                  {claimType === "AMOUNT" ? (
                    <AmountInput
                      className="w-32"
                      placeholder="0.00"
                      value={values[p.id] ?? ""}
                      onChange={(e) => setValues((v) => ({ ...v, [p.id]: e.target.value }))}
                    />
                  ) : (
                    <input
                      className="border-input focus-visible:ring-ring/50 h-9 w-32 rounded-md border bg-transparent px-3 text-sm outline-none focus-visible:ring-3"
                      inputMode="decimal"
                      placeholder="0"
                      value={values[p.id] ?? ""}
                      onChange={(e) => setValues((v) => ({ ...v, [p.id]: e.target.value }))}
                    />
                  )}
                </div>
              ))}
            </div>

            <DialogFooter>
              <Button
                onClick={() => customClaimMutation.mutate()}
                disabled={customClaimMutation.isPending}
              >
                {customClaimMutation.isPending ? "Saving…" : "Save claims"}
              </Button>
            </DialogFooter>
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}
