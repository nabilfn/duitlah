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
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { extractInviteToken } from "@/lib/group-invite";
import { joinGroupSchema, type JoinGroupInput } from "@/lib/validation/group";
import type { Group } from "@/types/group";

export function JoinGroupDialog() {
  const [open, setOpen] = useState(false);
  const router = useRouter();
  const queryClient = useQueryClient();
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<JoinGroupInput>({ resolver: zodResolver(joinGroupSchema) });

  const joinMutation = useMutation({
    mutationFn: (values: JoinGroupInput) =>
      apiClient.post<Group>("/api/v1/groups/join", { token: extractInviteToken(values.token) }),
    onSuccess: (group) => {
      queryClient.invalidateQueries({ queryKey: ["groups"] });
      toast.success(`Joined ${group.name}.`);
      reset();
      setOpen(false);
      router.push(`/groups/${group.id}`);
    },
    onError: (error) => {
      toast.error(
        error instanceof ApiRequestError ? error.error.message : "That invite link didn't work.",
      );
    },
  });

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger render={<Button variant="outline" />}>Join group</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Join a group</DialogTitle>
          <DialogDescription>Paste the invite link someone shared with you.</DialogDescription>
        </DialogHeader>
        <form
          onSubmit={handleSubmit((values) => joinMutation.mutate(values))}
          className="space-y-4"
        >
          <div className="grid gap-1.5">
            <Label htmlFor="token">Invite link</Label>
            <Input id="token" placeholder="https://…/groups/join?token=…" {...register("token")} />
            {errors.token && <p className="text-destructive text-sm">{errors.token.message}</p>}
          </div>

          <DialogFooter>
            <Button type="submit" disabled={isSubmitting}>
              {isSubmitting ? "Joining…" : "Join group"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
