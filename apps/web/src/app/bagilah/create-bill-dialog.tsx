"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { useForm } from "react-hook-form";
import { toast } from "sonner";
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
import { createBillSchema, type CreateBillInput } from "@/lib/validation/bagilah";
import type { Bill } from "@/types/bagilah";

export function CreateBillDialog() {
  const [open, setOpen] = useState(false);
  const router = useRouter();
  const queryClient = useQueryClient();
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<CreateBillInput>({
    resolver: zodResolver(createBillSchema),
    defaultValues: { receiptDate: new Date().toISOString().slice(0, 10) },
  });

  const createMutation = useMutation({
    mutationFn: (values: CreateBillInput) =>
      apiClient.post<Bill>("/api/v1/bills", {
        merchant: values.merchant || null,
        receiptDate: values.receiptDate,
      }),
    onSuccess: (bill) => {
      queryClient.invalidateQueries({ queryKey: ["bills"] });
      toast.success("Bill started.");
      reset({ receiptDate: new Date().toISOString().slice(0, 10) });
      setOpen(false);
      router.push(`/bagilah/${bill.id}`);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button />}>New bill</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Start a bill</DialogTitle>
        </DialogHeader>
        <form
          onSubmit={handleSubmit((values) => createMutation.mutate(values))}
          className="space-y-4"
        >
          <div className="grid gap-1.5">
            <Label htmlFor="merchant">Where was this?</Label>
            <Input id="merchant" placeholder="Mamak Corner" {...register("merchant")} />
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="receiptDate">Date</Label>
            <Input id="receiptDate" type="date" {...register("receiptDate")} />
            {errors.receiptDate && (
              <p className="text-destructive text-sm">{errors.receiptDate.message}</p>
            )}
          </div>

          <DialogFooter>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Starting…" : "Start bill"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
