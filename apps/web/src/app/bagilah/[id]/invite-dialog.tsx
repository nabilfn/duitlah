"use client";

import { useMutation } from "@tanstack/react-query";
import { CheckIcon, CopyIcon } from "lucide-react";
import { useState } from "react";
import { QRCodeSVG } from "qrcode.react";
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
import { buildBagilahInviteUrl } from "@/lib/bagilah-invite";

export function InviteDialog({ billId }: { billId: string }) {
  const [open, setOpen] = useState(false);
  const [link, setLink] = useState<string | null>(null);
  const [copied, setCopied] = useState(false);

  const generateMutation = useMutation({
    mutationFn: () => apiClient.post<{ token: string }>(`/api/v1/bills/${billId}/invite-token`),
    onSuccess: (res) => setLink(buildBagilahInviteUrl(res.token)),
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
      <DialogTrigger render={<Button variant="outline" size="sm" />}>Invite</DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Invite people to this bill</DialogTitle>
          <DialogDescription>
            Anyone with this link or QR code can join — no account needed to claim items.
            Regenerating it invalidates the old one.
          </DialogDescription>
        </DialogHeader>

        {link && !generateMutation.isPending && (
          <div className="flex justify-center rounded-lg border p-4">
            <QRCodeSVG value={link} size={192} />
          </div>
        )}

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
