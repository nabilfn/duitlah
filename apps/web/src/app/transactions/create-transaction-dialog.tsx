"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";
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
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { AmountInput } from "@/components/finance/amount-input";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { createTransactionSchema, type CreateTransactionInput } from "@/lib/validation/finance";
import type { Account, Category, Transaction } from "@/types/finance";

export function CreateTransactionDialog({ accounts }: { accounts: Account[] }) {
  const [open, setOpen] = useState(false);
  const queryClient = useQueryClient();
  const {
    control,
    register,
    handleSubmit,
    reset,
    watch,
    formState: { errors, isSubmitting },
  } = useForm<CreateTransactionInput>({
    resolver: zodResolver(createTransactionSchema),
    defaultValues: {
      type: "EXPENSE",
      accountId: accounts[0]?.id ?? "",
      occurredOn: new Date().toISOString().slice(0, 10),
    },
  });
  const type = watch("type");

  const { data: categories } = useQuery({
    queryKey: ["categories"],
    queryFn: () => apiClient.get<Category[]>("/api/v1/categories"),
  });
  const categoryOptions = categories?.filter((c) => c.type === type && c.parentId !== null) ?? [];

  const createMutation = useMutation({
    mutationFn: (values: CreateTransactionInput) =>
      apiClient.post<Transaction>("/api/v1/transactions", values),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["transactions"] });
      queryClient.invalidateQueries({ queryKey: ["accounts"] });
      queryClient.invalidateQueries({ queryKey: ["dashboard"] });
      toast.success("Transaction added.");
      reset({
        type,
        accountId: accounts[0]?.id ?? "",
        occurredOn: new Date().toISOString().slice(0, 10),
      });
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button />}>Add transaction</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Add a transaction</DialogTitle>
        </DialogHeader>
        <form
          onSubmit={handleSubmit((values) => createMutation.mutate(values))}
          className="space-y-4"
        >
          <Controller
            name="type"
            control={control}
            render={({ field }) => (
              <div className="grid grid-cols-2 gap-2">
                <Button
                  type="button"
                  variant={field.value === "EXPENSE" ? "default" : "outline"}
                  onClick={() => field.onChange("EXPENSE")}
                >
                  Expense
                </Button>
                <Button
                  type="button"
                  variant={field.value === "INCOME" ? "default" : "outline"}
                  onClick={() => field.onChange("INCOME")}
                >
                  Income
                </Button>
              </div>
            )}
          />

          <div className="grid gap-1.5">
            <Label htmlFor="accountId">Account</Label>
            <Controller
              name="accountId"
              control={control}
              render={({ field }) => (
                <Select value={field.value} onValueChange={field.onChange}>
                  <SelectTrigger id="accountId" className="w-full">
                    <SelectValue placeholder="Choose an account" />
                  </SelectTrigger>
                  <SelectContent>
                    {accounts.map((a) => (
                      <SelectItem key={a.id} value={a.id}>
                        {a.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            />
            {errors.accountId && (
              <p className="text-destructive text-sm">{errors.accountId.message}</p>
            )}
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="categoryId">Category</Label>
            <Controller
              name="categoryId"
              control={control}
              render={({ field }) => (
                <Select value={field.value} onValueChange={field.onChange}>
                  <SelectTrigger id="categoryId" className="w-full">
                    <SelectValue placeholder="Optional" />
                  </SelectTrigger>
                  <SelectContent>
                    {categoryOptions.map((c) => (
                      <SelectItem key={c.id} value={c.id}>
                        {c.icon} {c.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            />
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="amount">Amount</Label>
            <Controller
              name="amount"
              control={control}
              render={({ field }) => (
                <AmountInput
                  id="amount"
                  placeholder="0.00"
                  value={field.value}
                  onChange={field.onChange}
                />
              )}
            />
            {errors.amount && <p className="text-destructive text-sm">{errors.amount.message}</p>}
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="merchant">Merchant</Label>
            <Input id="merchant" placeholder="Optional" {...register("merchant")} />
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="occurredOn">Date</Label>
            <Input id="occurredOn" type="date" {...register("occurredOn")} />
            {errors.occurredOn && (
              <p className="text-destructive text-sm">{errors.occurredOn.message}</p>
            )}
          </div>

          <DialogFooter>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Adding…" : "Add transaction"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
