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
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { addItemSchema, type AddItemInput } from "@/lib/validation/bagilah";
import type { ReceiptItem } from "@/types/bagilah";

export function AddItemDialog({ billId }: { billId: string }) {
  const [open, setOpen] = useState(false);
  const queryClient = useQueryClient();
  const {
    control,
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<AddItemInput>({
    resolver: zodResolver(addItemSchema),
    defaultValues: { quantity: "1" },
  });

  const addMutation = useMutation({
    mutationFn: (values: AddItemInput) =>
      apiClient.post<ReceiptItem>(`/api/v1/bills/${billId}/items`, {
        name: values.name,
        quantity: values.quantity,
        unitPrice: values.unitPrice,
        itemDiscount: values.itemDiscount || "0",
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["bill-items", billId] });
      queryClient.invalidateQueries({ queryKey: ["bill-breakdown", billId] });
      toast.success("Item added.");
      reset({ quantity: "1" });
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button size="sm" variant="outline" />}>Add item</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Add a receipt item</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit((values) => addMutation.mutate(values))} className="space-y-4">
          <div className="grid gap-1.5">
            <Label htmlFor="name">Item</Label>
            <Input id="name" placeholder="Nasi Goreng" {...register("name")} />
            {errors.name && <p className="text-destructive text-sm">{errors.name.message}</p>}
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="grid gap-1.5">
              <Label htmlFor="quantity">Quantity</Label>
              <Input id="quantity" inputMode="decimal" {...register("quantity")} />
              {errors.quantity && (
                <p className="text-destructive text-sm">{errors.quantity.message}</p>
              )}
            </div>
            <div className="grid gap-1.5">
              <Label htmlFor="unitPrice">Unit price</Label>
              <Controller
                name="unitPrice"
                control={control}
                render={({ field }) => (
                  <AmountInput
                    id="unitPrice"
                    placeholder="0.00"
                    value={field.value}
                    onChange={field.onChange}
                  />
                )}
              />
              {errors.unitPrice && (
                <p className="text-destructive text-sm">{errors.unitPrice.message}</p>
              )}
            </div>
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="itemDiscount">Item discount (optional)</Label>
            <Controller
              name="itemDiscount"
              control={control}
              render={({ field }) => (
                <AmountInput
                  id="itemDiscount"
                  placeholder="0.00"
                  value={field.value}
                  onChange={field.onChange}
                />
              )}
            />
          </div>

          <DialogFooter>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Adding…" : "Add item"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
