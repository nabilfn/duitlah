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
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { AmountInput } from "@/components/finance/amount-input";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { createGoalSchema, goalTypes, type CreateGoalInput } from "@/lib/validation/budget";

export function CreateGoalDialog() {
  const [open, setOpen] = useState(false);
  const queryClient = useQueryClient();
  const {
    control,
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<CreateGoalInput>({
    resolver: zodResolver(createGoalSchema),
    defaultValues: { type: "CUSTOM" },
  });

  const createMutation = useMutation({
    mutationFn: (values: CreateGoalInput) =>
      apiClient.post("/api/v1/goals", {
        name: values.name,
        type: values.type,
        targetAmount: values.targetAmount,
        targetDate: values.targetDate || null,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["goals"] });
      toast.success("Goal added.");
      reset();
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button />}>Add goal</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Add a goal</DialogTitle>
        </DialogHeader>
        <form
          onSubmit={handleSubmit((values) => createMutation.mutate(values))}
          className="space-y-4"
        >
          <div className="grid gap-1.5">
            <Label htmlFor="name">Name</Label>
            <Input id="name" placeholder="Japan Trip" {...register("name")} />
            {errors.name && <p className="text-destructive text-sm">{errors.name.message}</p>}
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="type">Type</Label>
            <Controller
              name="type"
              control={control}
              render={({ field }) => (
                <Select value={field.value} onValueChange={field.onChange}>
                  <SelectTrigger id="type" className="w-full">
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {goalTypes.map((t) => (
                      <SelectItem key={t.value} value={t.value}>
                        {t.icon} {t.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            />
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="targetAmount">Target amount</Label>
            <Controller
              name="targetAmount"
              control={control}
              render={({ field }) => (
                <AmountInput
                  id="targetAmount"
                  placeholder="0.00"
                  value={field.value}
                  onChange={field.onChange}
                />
              )}
            />
            {errors.targetAmount && (
              <p className="text-destructive text-sm">{errors.targetAmount.message}</p>
            )}
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="targetDate">Target date</Label>
            <Input id="targetDate" type="date" {...register("targetDate")} />
          </div>

          <DialogFooter>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Adding…" : "Add goal"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
