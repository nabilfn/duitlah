"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useState } from "react";
import { toast } from "sonner";
import { AmountInput } from "@/components/finance/amount-input";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import type { Participant, Payment } from "@/types/bagilah";

export function RecordPaymentDialog({
  billId,
  participant,
  existingAmount,
}: {
  billId: string;
  participant: Participant;
  existingAmount?: string;
}) {
  const [open, setOpen] = useState(false);
  const [amount, setAmount] = useState(existingAmount ?? "");
  const queryClient = useQueryClient();

  const mutation = useMutation({
    mutationFn: () =>
      apiClient.put<Payment>(`/api/v1/bills/${billId}/payments/${participant.id}`, {
        amountPaid: amount,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["bill-payments", billId] });
      queryClient.invalidateQueries({ queryKey: ["bill-balances", billId] });
      toast.success("Payment recorded.");
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button size="sm" variant="outline" />}>
        {existingAmount ? "Edit payment" : "Record payment"}
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>How much did {participant.displayName} pay?</DialogTitle>
        </DialogHeader>
        <div className="space-y-4">
          <div className="grid gap-1.5">
            <Label htmlFor="amountPaid">Amount paid</Label>
            <AmountInput
              id="amountPaid"
              placeholder="0.00"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
            />
          </div>
          <DialogFooter>
            <Button onClick={() => mutation.mutate()} disabled={mutation.isPending || !amount}>
              {mutation.isPending ? "Saving…" : "Save"}
            </Button>
          </DialogFooter>
        </div>
      </DialogContent>
    </Dialog>
  );
}
