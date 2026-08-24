"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
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
import { AmountInput } from "@/components/finance/amount-input";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { addContributionSchema, type AddContributionInput } from "@/lib/validation/budget";

export function AddContributionDialog({ goalId, goalName }: { goalId: string; goalName: string }) {
  const [open, setOpen] = useState(false);
  const queryClient = useQueryClient();
  const {
    control,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<AddContributionInput>({
    resolver: zodResolver(addContributionSchema),
    defaultValues: { occurredOn: new Date().toISOString().slice(0, 10) },
  });

  const contributeMutation = useMutation({
    mutationFn: (values: AddContributionInput) =>
      apiClient.post(`/api/v1/goals/${goalId}/contributions`, values),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["goals"] });
      toast.success("Contribution added.");
      reset({ occurredOn: new Date().toISOString().slice(0, 10) });
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button size="sm" variant="outline" />}>
        Add contribution
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Contribute to {goalName}</DialogTitle>
        </DialogHeader>
        <form
          onSubmit={handleSubmit((values) => contributeMutation.mutate(values))}
          className="space-y-4"
        >
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
            <p className="text-muted-foreground text-xs">
              Use a negative amount to correct or withdraw.
            </p>
            {errors.amount && <p className="text-destructive text-sm">{errors.amount.message}</p>}
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="occurredOn">Date</Label>
            <Controller
              name="occurredOn"
              control={control}
              render={({ field }) => <Input id="occurredOn" type="date" {...field} />}
            />
          </div>

          <DialogFooter>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Adding…" : "Add contribution"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
