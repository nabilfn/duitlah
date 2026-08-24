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
import { createBudgetSchema, type CreateBudgetInput } from "@/lib/validation/budget";
import type { Category } from "@/types/finance";

export function CreateBudgetDialog({
  periodYear,
  periodMonth,
}: {
  periodYear: number;
  periodMonth: number;
}) {
  const [open, setOpen] = useState(false);
  const queryClient = useQueryClient();
  const {
    control,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<CreateBudgetInput>({ resolver: zodResolver(createBudgetSchema) });

  const { data: categories } = useQuery({
    queryKey: ["categories"],
    queryFn: () => apiClient.get<Category[]>("/api/v1/categories"),
  });
  // Parents and leaves both offered — a budget on "Food" rolls up its children automatically.
  const expenseCategories = categories?.filter((c) => c.type === "EXPENSE") ?? [];

  const createMutation = useMutation({
    mutationFn: (values: CreateBudgetInput) =>
      apiClient.post("/api/v1/budgets", {
        categoryId: values.categoryId || null,
        periodYear,
        periodMonth,
        amountLimit: values.amountLimit,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["budgets"] });
      toast.success("Budget added.");
      reset();
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button />}>Add budget</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Add a budget</DialogTitle>
        </DialogHeader>
        <form
          onSubmit={handleSubmit((values) => createMutation.mutate(values))}
          className="space-y-4"
        >
          <div className="grid gap-1.5">
            <Label htmlFor="categoryId">Category</Label>
            <Controller
              name="categoryId"
              control={control}
              render={({ field }) => (
                <Select value={field.value} onValueChange={field.onChange}>
                  <SelectTrigger id="categoryId" className="w-full">
                    <SelectValue placeholder="Overall (all spending)" />
                  </SelectTrigger>
                  <SelectContent>
                    {expenseCategories.map((c) => (
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
            <Label htmlFor="amountLimit">Monthly limit</Label>
            <Controller
              name="amountLimit"
              control={control}
              render={({ field }) => (
                <AmountInput
                  id="amountLimit"
                  placeholder="0.00"
                  value={field.value}
                  onChange={field.onChange}
                />
              )}
            />
            {errors.amountLimit && (
              <p className="text-destructive text-sm">{errors.amountLimit.message}</p>
            )}
          </div>

          <DialogFooter>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Adding…" : "Add budget"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
