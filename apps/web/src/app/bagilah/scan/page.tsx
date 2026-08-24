"use client";

import { useMutation } from "@tanstack/react-query";
import { CameraIcon, ImageUpIcon } from "lucide-react";
import { useRouter } from "next/navigation";
import { useRef } from "react";
import { toast } from "sonner";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { Button } from "@/components/ui/button";
import { ApiRequestError } from "@/lib/api-client";
import { uploadReceiptScan } from "@/lib/receipt-scan-client";

export default function ScanReceiptPage() {
  const router = useRouter();
  const cameraInputRef = useRef<HTMLInputElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const uploadMutation = useMutation({
    mutationFn: uploadReceiptScan,
    onSuccess: (scan) => router.push(`/bagilah/scan/${scan.id}`),
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  function handleFileChange(event: React.ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0];
    if (file) uploadMutation.mutate(file);
    event.target.value = "";
  }

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto flex max-w-md flex-col items-center gap-6 px-4 py-16 text-center">
          <div className="space-y-1">
            <h1 className="text-2xl font-semibold tracking-tight">Scan a receipt</h1>
            <p className="text-muted-foreground text-sm">
              Take a photo or upload one — you&apos;ll get a chance to check and correct everything
              before it becomes a bill.
            </p>
          </div>

          {uploadMutation.isPending ? (
            <p className="text-muted-foreground text-sm">Reading your receipt…</p>
          ) : (
            <div className="flex w-full flex-col gap-3">
              <Button size="lg" onClick={() => cameraInputRef.current?.click()}>
                <CameraIcon className="size-4" />
                Take a photo
              </Button>
              <Button size="lg" variant="outline" onClick={() => fileInputRef.current?.click()}>
                <ImageUpIcon className="size-4" />
                Upload a photo
              </Button>
            </div>
          )}

          <input
            ref={cameraInputRef}
            type="file"
            accept="image/*"
            capture="environment"
            className="hidden"
            onChange={handleFileChange}
          />
          <input
            ref={fileInputRef}
            type="file"
            accept="image/jpeg,image/png,image/webp,image/heic"
            className="hidden"
            onChange={handleFileChange}
          />
        </div>
      </AppShell>
    </RequireAuth>
  );
}
