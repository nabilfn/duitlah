"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";
import { toast } from "sonner";
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
import { createGroupExpenseSchema, type CreateGroupExpenseInput } from "@/lib/validation/group";
import type { GroupExpense, GroupMember } from "@/types/group";

export function CreateExpenseDialog({
  groupId,
  members,
}: {
  groupId: string;
  members: GroupMember[];
}) {
  const [open, setOpen] = useState(false);
  const [participantIds, setParticipantIds] = useState<Set<string>>(
    new Set(members.map((m) => m.userId)),
  );
  const queryClient = useQueryClient();
  const {
    control,
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<CreateGroupExpenseInput>({
    resolver: zodResolver(createGroupExpenseSchema),
    defaultValues: { occurredOn: new Date().toISOString().slice(0, 10) },
  });

  const createMutation = useMutation({
    mutationFn: (values: CreateGroupExpenseInput) =>
      apiClient.post<GroupExpense>(`/api/v1/groups/${groupId}/expenses`, {
        ...values,
        participantUserIds: Array.from(participantIds),
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["group-expenses", groupId] });
      queryClient.invalidateQueries({ queryKey: ["group-balances", groupId] });
      toast.success("Expense added.");
      reset({ occurredOn: new Date().toISOString().slice(0, 10) });
      setParticipantIds(new Set(members.map((m) => m.userId)));
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  function toggleParticipant(userId: string) {
    setParticipantIds((prev) => {
      const next = new Set(prev);
      if (next.has(userId)) next.delete(userId);
      else next.add(userId);
      return next;
    });
  }

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button />}>Add expense</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Add a shared expense</DialogTitle>
        </DialogHeader>
        <form
          onSubmit={handleSubmit((values) => createMutation.mutate(values))}
          className="space-y-4"
        >
          <div className="grid gap-1.5">
            <Label htmlFor="description">What was it for?</Label>
            <Input id="description" placeholder="Groceries" {...register("description")} />
            {errors.description && (
              <p className="text-destructive text-sm">{errors.description.message}</p>
            )}
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
            <Label htmlFor="paidByUserId">Who paid?</Label>
            <Controller
              name="paidByUserId"
              control={control}
              render={({ field }) => (
                <Select value={field.value} onValueChange={field.onChange}>
                  <SelectTrigger id="paidByUserId" className="w-full">
                    <SelectValue placeholder="You" />
                  </SelectTrigger>
                  <SelectContent>
                    {members.map((m) => (
                      <SelectItem key={m.userId} value={m.userId}>
                        {m.displayName}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            />
          </div>

          <div className="grid gap-1.5">
            <Label htmlFor="occurredOn">Date</Label>
            <Input id="occurredOn" type="date" {...register("occurredOn")} />
          </div>

          <div className="grid gap-1.5">
            <Label>Split between</Label>
            <div className="space-y-2">
              {members.map((m) => (
                <label key={m.userId} className="flex items-center gap-2 text-sm">
                  <Checkbox
                    checked={participantIds.has(m.userId)}
                    onCheckedChange={() => toggleParticipant(m.userId)}
                  />
                  {m.displayName}
                </label>
              ))}
            </div>
          </div>

          <DialogFooter>
            <Button type="submit" disabled={isSubmitting || participantIds.size === 0}>
              {isSubmitting ? "Adding…" : "Add expense"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
