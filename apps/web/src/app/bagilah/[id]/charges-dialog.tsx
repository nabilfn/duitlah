"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";
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
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { updateBillChargesSchema, type UpdateBillChargesInput } from "@/lib/validation/bagilah";
import type { Bill } from "@/types/bagilah";

export function ChargesDialog({ bill }: { bill: Bill }) {
  const [open, setOpen] = useState(false);
  const queryClient = useQueryClient();
  const {
    control,
    register,
    handleSubmit,
    formState: { isSubmitting },
  } = useForm<UpdateBillChargesInput>({
    resolver: zodResolver(updateBillChargesSchema),
    defaultValues: {
      tax: bill.tax,
      taxStrategy: bill.taxStrategy,
      serviceCharge: bill.serviceCharge,
      serviceStrategy: bill.serviceStrategy,
      discount: bill.discount,
      discountLabel: bill.discountLabel ?? "",
      declaredTotal: bill.declaredTotal ?? "",
    },
  });

  const mutation = useMutation({
    mutationFn: (values: UpdateBillChargesInput) =>
      apiClient.patch<Bill>(`/api/v1/bills/${bill.id}`, {
        merchant: bill.merchant,
        receiptDate: bill.receiptDate,
        tax: values.tax,
        taxStrategy: values.taxStrategy,
        serviceCharge: values.serviceCharge,
        serviceStrategy: values.serviceStrategy,
        discount: values.discount,
        discountLabel: values.discountLabel || null,
        declaredTotal: values.declaredTotal || null,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["bill", bill.id] });
      queryClient.invalidateQueries({ queryKey: ["bill-breakdown", bill.id] });
      toast.success("Charges updated.");
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button size="sm" variant="outline" />}>
        Tax, service &amp; discount
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Tax, service charge &amp; discount</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit((values) => mutation.mutate(values))} className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div className="grid gap-1.5">
              <Label htmlFor="tax">Tax (SST)</Label>
              <Controller
                name="tax"
                control={control}
                render={({ field }) => (
                  <AmountInput
                    id="tax"
                    placeholder="0.00"
                    value={field.value}
                    onChange={field.onChange}
                  />
                )}
              />
            </div>
            <div className="grid gap-1.5">
              <Label htmlFor="taxStrategy">Split tax</Label>
              <Controller
                name="taxStrategy"
                control={control}
                render={({ field }) => (
                  <Select value={field.value} onValueChange={field.onChange}>
                    <SelectTrigger id="taxStrategy" className="w-full">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="PROPORTIONAL">By subtotal share</SelectItem>
                      <SelectItem value="EQUAL">Equally</SelectItem>
                    </SelectContent>
                  </Select>
                )}
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="grid gap-1.5">
              <Label htmlFor="serviceCharge">Service charge</Label>
              <Controller
                name="serviceCharge"
                control={control}
                render={({ field }) => (
                  <AmountInput
                    id="serviceCharge"
                    placeholder="0.00"
                    value={field.value}
                    onChange={field.onChange}
                  />
                )}
              />
            </div>
            <div className="grid gap-1.5">
              <Label htmlFor="serviceStrategy">Split service</Label>
              <Controller
                name="serviceStrategy"
                control={control}
                render={({ field }) => (
                  <Select value={field.value} onValueChange={field.onChange}>
                    <SelectTrigger id="serviceStrategy" className="w-full">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="PROPORTIONAL">By subtotal share</SelectItem>
                      <SelectItem value="EQUAL">Equally</SelectItem>
                    </SelectContent>
                  </Select>
                )}
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="grid gap-1.5">
              <Label htmlFor="discount">Discount / voucher</Label>
              <Controller
                name="discount"
                control={control}
                render={({ field }) => (
                  <AmountInput
                    id="discount"
                    placeholder="0.00"
                    value={field.value}
                    onChange={field.onChange}
                  />
                )}
              />
            </div>
            <div className="grid gap-1.5">
              <Label htmlFor="discountLabel">Discount label</Label>
              <Input
                id="discountLabel"
                placeholder="Birthday voucher"
                {...register("discountLabel")}
              />
            </div>
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="declaredTotal">Receipt total (optional)</Label>
            <Controller
              name="declaredTotal"
              control={control}
              render={({ field }) => (
                <AmountInput
                  id="declaredTotal"
                  placeholder="Leave blank to use the computed total"
                  value={field.value}
                  onChange={field.onChange}
                />
              )}
            />
            <p className="text-muted-foreground text-xs">
              If what&apos;s printed on the receipt is a cent or two off from the computed total
              (common with cash rounding), enter it here — the difference is recorded and split,
              never dropped.
            </p>
          </div>

          <DialogFooter>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Saving…" : "Save"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
