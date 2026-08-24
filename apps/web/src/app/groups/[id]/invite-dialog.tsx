"use client";

import { useMutation } from "@tanstack/react-query";
import { CheckIcon, CopyIcon } from "lucide-react";
import { useState } from "react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { buildInviteUrl } from "@/lib/group-invite";

export function InviteDialog({ groupId }: { groupId: string }) {
  const [open, setOpen] = useState(false);
  const [link, setLink] = useState<string | null>(null);
  const [copied, setCopied] = useState(false);

  const generateMutation = useMutation({
    mutationFn: () => apiClient.post<{ token: string }>(`/api/v1/groups/${groupId}/invite-token`),
    onSuccess: (res) => setLink(buildInviteUrl(res.token)),
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  function handleOpenChange(next: boolean) {
    setOpen(next);
    setCopied(false);
    if (next && !link) generateMutation.mutate();
  }

  async function handleCopy() {
    if (!link) return;
    await navigator.clipboard.writeText(link);
    setCopied(true);
  }

  return (
    <Dialog open={open} onOpenChange={handleOpenChange}>
      <DialogTrigger render={<Button variant="outline" />}>Invite</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Invite to this group</DialogTitle>
          <DialogDescription>
            Anyone with this link can join. Regenerating it invalidates the old one.
          </DialogDescription>
        </DialogHeader>
        <div className="flex gap-2">
          <Input readOnly value={generateMutation.isPending ? "Generating…" : (link ?? "")} />
          <Button
            variant="outline"
            size="icon"
            onClick={handleCopy}
            disabled={!link}
            aria-label="Copy invite link"
          >
            {copied ? <CheckIcon /> : <CopyIcon />}
          </Button>
        </div>
        <Button
          variant="ghost"
          size="sm"
          onClick={() => generateMutation.mutate()}
          disabled={generateMutation.isPending}
        >
          Generate a new link
        </Button>
      </DialogContent>
    </Dialog>
  );
}
