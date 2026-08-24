"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
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
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { addParticipantSchema, type AddParticipantInput } from "@/lib/validation/bagilah";
import type { Participant } from "@/types/bagilah";
import type { GroupMember } from "@/types/group";

export function AddParticipantDialog({
  billId,
  groupId,
  existingParticipants,
}: {
  billId: string;
  groupId: string | null;
  existingParticipants: Participant[];
}) {
  const [open, setOpen] = useState(false);
  const queryClient = useQueryClient();

  const { data: groupMembers } = useQuery({
    queryKey: ["group-members", groupId],
    queryFn: () => apiClient.get<GroupMember[]>(`/api/v1/groups/${groupId}/members`),
    enabled: Boolean(groupId) && open,
  });
  const addedUserIds = new Set(existingParticipants.map((p) => p.userId).filter(Boolean));
  const availableMembers = (groupMembers ?? []).filter((m) => !addedUserIds.has(m.userId));

  const {
    register,
    handleSubmit,
    reset,
    setValue,
    watch,
    formState: { errors, isSubmitting },
  } = useForm<AddParticipantInput>({ resolver: zodResolver(addParticipantSchema) });

  const addMutation = useMutation({
    mutationFn: (values: AddParticipantInput) =>
      apiClient.post<Participant>(`/api/v1/bills/${billId}/participants`, {
        userId: values.userId || null,
        guestName: values.guestName || null,
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["bill-participants", billId] });
      queryClient.invalidateQueries({ queryKey: ["bill-breakdown", billId] });
      toast.success("Participant added.");
      reset();
      setOpen(false);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button size="sm" variant="outline" />}>Add participant</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Add a participant</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit((values) => addMutation.mutate(values))} className="space-y-4">
          {availableMembers.length > 0 && (
            <div className="grid gap-1.5">
              <Label htmlFor="userId">From the group</Label>
              <Select
                value={watch("userId")}
                onValueChange={(v) => {
                  setValue("userId", v ?? "");
                  setValue("guestName", "");
                }}
              >
                <SelectTrigger id="userId" className="w-full">
                  <SelectValue placeholder="Pick a group member" />
                </SelectTrigger>
                <SelectContent>
                  {availableMembers.map((m) => (
                    <SelectItem key={m.userId} value={m.userId}>
                      {m.displayName}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          )}

          <div className="grid gap-1.5">
            <Label htmlFor="guestName">Or a guest name (no account needed)</Label>
            <Input
              id="guestName"
              placeholder="Syazmir"
              {...register("guestName", {
                onChange: () => setValue("userId", ""),
              })}
            />
            {errors.guestName && (
              <p className="text-destructive text-sm">{errors.guestName.message}</p>
            )}
          </div>

          <DialogFooter>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Adding…" : "Add participant"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
