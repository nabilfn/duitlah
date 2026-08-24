"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQuery } from "@tanstack/react-query";
import { PlusIcon, TrashIcon } from "lucide-react";
import { useRouter } from "next/navigation";
import { use, useEffect } from "react";
import { Controller, useFieldArray, useForm } from "react-hook-form";
import { toast } from "sonner";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { AmountInput } from "@/components/finance/amount-input";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { confirmScanSchema, type ConfirmScanInput } from "@/lib/validation/receipt-scan";
import { cn } from "@/lib/utils";
import type { ReceiptScan } from "@/types/receipt-scan";

const LOW_CONFIDENCE_THRESHOLD = 0.6;

function ConfidenceHint({ confidence }: { confidence: number }) {
  if (confidence >= LOW_CONFIDENCE_THRESHOLD) return null;
  return <p className="text-warning text-xs">Double-check this — the scan wasn&apos;t sure.</p>;
}

export default function ReviewScanPage({ params }: { params: Promise<{ id: string }> }) {
  const { id: scanId } = use(params);
  const router = useRouter();

  const { data: scan, isLoading } = useQuery({
    queryKey: ["receipt-scan", scanId],
    queryFn: () => apiClient.get<ReceiptScan>(`/api/v1/receipts/scans/${scanId}`),
  });

  const {
    control,
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<ConfirmScanInput>({
    resolver: zodResolver(confirmScanSchema),
    defaultValues: {
      taxStrategy: "PROPORTIONAL",
      serviceStrategy: "PROPORTIONAL",
      tax: "0.00",
      serviceCharge: "0.00",
      discount: "0.00",
      items: [],
    },
  });
  const { fields, append, remove } = useFieldArray({ control, name: "items" });

  useEffect(() => {
    if (!scan) return;
    const parsed = scan.parsedReceipt;
    reset({
      merchant: parsed.merchant ?? "",
      receiptDate: parsed.receiptDate ?? new Date().toISOString().slice(0, 10),
      items:
        parsed.items.length > 0
          ? parsed.items.map((item) => ({
              name: item.name ?? "",
              quantity: item.quantity ?? "1",
              unitPrice: item.unitPrice ?? "0.00",
            }))
          : [{ name: "", quantity: "1", unitPrice: "0.00" }],
      tax: parsed.tax ?? "0.00",
      taxStrategy: "PROPORTIONAL",
      serviceCharge: parsed.serviceCharge ?? "0.00",
      serviceStrategy: "PROPORTIONAL",
      discount: parsed.discount ?? "0.00",
      discountLabel: "",
      declaredTotal: parsed.total ?? "",
    });
  }, [scan, reset]);

  const confirmMutation = useMutation({
    mutationFn: (values: ConfirmScanInput) =>
      apiClient.post<{ id: string }>(`/api/v1/receipts/scans/${scanId}/confirm`, {
        merchant: values.merchant || null,
        receiptDate: values.receiptDate,
        items: values.items.map((item) => ({
          name: item.name,
          quantity: item.quantity,
          unitPrice: item.unitPrice,
        })),
        tax: values.tax,
        taxStrategy: values.taxStrategy,
        serviceCharge: values.serviceCharge,
        serviceStrategy: values.serviceStrategy,
        discount: values.discount,
        discountLabel: values.discountLabel || null,
        declaredTotal: values.declaredTotal || null,
      }),
    onSuccess: (bill) => {
      toast.success("Bill created.");
      router.push(`/bagilah/${bill.id}`);
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  const parsed = scan?.parsedReceipt;
  const itemConfidences = parsed?.items.map((i) => i.confidence) ?? [];

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          <h1 className="text-2xl font-semibold tracking-tight">Check your receipt</h1>

          {isLoading && <Skeleton className="h-64 w-full" />}

          {scan && (
            <>
              {/* eslint-disable-next-line @next/next/no-img-element -- a private, presigned S3 URL; next/image's remote-pattern allowlist doesn't apply here */}
              <img
                src={scan.imageUrl}
                alt="Scanned receipt"
                className="max-h-80 w-full rounded-lg border object-contain"
              />

              {scan.status === "FAILED" && (
                <div className="bg-warning/10 text-warning-foreground rounded-md p-3 text-sm">
                  {scan.errorMessage ?? "Couldn't read this receipt automatically."} Fill in the
                  details below.
                </div>
              )}
              {scan.status === "PARSED" &&
                scan.overallConfidence !== null &&
                scan.overallConfidence < LOW_CONFIDENCE_THRESHOLD && (
                  <div className="bg-warning/10 text-warning-foreground rounded-md p-3 text-sm">
                    This scan wasn&apos;t very confident — please double-check the fields below.
                  </div>
                )}

              <form
                onSubmit={handleSubmit((values) => confirmMutation.mutate(values))}
                className="space-y-6"
              >
                <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-1.5">
                    <Label htmlFor="merchant">Merchant</Label>
                    <Input id="merchant" placeholder="Mamak Corner" {...register("merchant")} />
                    {parsed && <ConfidenceHint confidence={parsed.merchantConfidence} />}
                  </div>
                  <div className="grid gap-1.5">
                    <Label htmlFor="receiptDate">Date</Label>
                    <Input id="receiptDate" type="date" {...register("receiptDate")} />
                    {errors.receiptDate && (
                      <p className="text-destructive text-sm">{errors.receiptDate.message}</p>
                    )}
                    {parsed && <ConfidenceHint confidence={parsed.receiptDateConfidence} />}
                  </div>
                </div>

                <div className="space-y-2">
                  <div className="flex items-center justify-between">
                    <Label>Items</Label>
                    <Button
                      type="button"
                      size="sm"
                      variant="outline"
                      onClick={() => append({ name: "", quantity: "1", unitPrice: "0.00" })}
                    >
                      <PlusIcon className="size-4" />
                      Add item
                    </Button>
                  </div>
                  {errors.items?.message && (
                    <p className="text-destructive text-sm">{errors.items.message}</p>
                  )}
                  {fields.map((field, index) => (
                    <Card key={field.id}>
                      <CardContent className="space-y-2">
                        <div className="flex items-start gap-2">
                          <div className="grid flex-1 gap-1.5">
                            <Input
                              placeholder="Item name"
                              {...register(`items.${index}.name` as const)}
                            />
                            {errors.items?.[index]?.name && (
                              <p className="text-destructive text-xs">
                                {errors.items[index]?.name?.message}
                              </p>
                            )}
                          </div>
                          <Button
                            type="button"
                            size="icon"
                            variant="ghost"
                            aria-label="Remove item"
                            onClick={() => remove(index)}
                          >
                            <TrashIcon className="size-4" />
                          </Button>
                        </div>
                        <div className="grid grid-cols-2 gap-2">
                          <div className="grid gap-1">
                            <Label className="text-muted-foreground text-xs">Quantity</Label>
                            <Input
                              inputMode="decimal"
                              {...register(`items.${index}.quantity` as const)}
                            />
                          </div>
                          <div className="grid gap-1">
                            <Label className="text-muted-foreground text-xs">Unit price</Label>
                            <Controller
                              name={`items.${index}.unitPrice` as const}
                              control={control}
                              render={({ field: priceField }) => (
                                <AmountInput
                                  placeholder="0.00"
                                  value={priceField.value}
                                  onChange={priceField.onChange}
                                />
                              )}
                            />
                          </div>
                        </div>
                        {itemConfidences[index] !== undefined && (
                          <ConfidenceHint confidence={itemConfidences[index]} />
                        )}
                      </CardContent>
                    </Card>
                  ))}
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-1.5">
                    <Label htmlFor="tax">Tax (SST)</Label>
                    <Controller
                      name="tax"
                      control={control}
                      render={({ field }) => (
                        <AmountInput
                          id="tax"
                          placeholder="0.00"
                          value={field.value}
                          onChange={field.onChange}
                        />
                      )}
                    />
                    {parsed && <ConfidenceHint confidence={parsed.taxConfidence} />}
                  </div>
                  <div className="grid gap-1.5">
                    <Label htmlFor="taxStrategy">Split tax</Label>
                    <Controller
                      name="taxStrategy"
                      control={control}
                      render={({ field }) => (
                        <Select value={field.value} onValueChange={field.onChange}>
                          <SelectTrigger id="taxStrategy" className="w-full">
                            <SelectValue />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="PROPORTIONAL">By subtotal share</SelectItem>
                            <SelectItem value="EQUAL">Equally</SelectItem>
                          </SelectContent>
                        </Select>
                      )}
                    />
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-1.5">
                    <Label htmlFor="serviceCharge">Service charge</Label>
                    <Controller
                      name="serviceCharge"
                      control={control}
                      render={({ field }) => (
                        <AmountInput
                          id="serviceCharge"
                          placeholder="0.00"
                          value={field.value}
                          onChange={field.onChange}
                        />
                      )}
                    />
                    {parsed && <ConfidenceHint confidence={parsed.serviceConfidence} />}
                  </div>
                  <div className="grid gap-1.5">
                    <Label htmlFor="serviceStrategy">Split service</Label>
                    <Controller
                      name="serviceStrategy"
                      control={control}
                      render={({ field }) => (
                        <Select value={field.value} onValueChange={field.onChange}>
                          <SelectTrigger id="serviceStrategy" className="w-full">
                            <SelectValue />
                          </SelectTrigger>
                          <SelectContent>
                            <SelectItem value="PROPORTIONAL">By subtotal share</SelectItem>
                            <SelectItem value="EQUAL">Equally</SelectItem>
                          </SelectContent>
                        </Select>
                      )}
                    />
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="grid gap-1.5">
                    <Label htmlFor="discount">Discount / voucher</Label>
                    <Controller
                      name="discount"
                      control={control}
                      render={({ field }) => (
                        <AmountInput
                          id="discount"
                          placeholder="0.00"
                          value={field.value}
                          onChange={field.onChange}
                        />
                      )}
                    />
                    {parsed && <ConfidenceHint confidence={parsed.discountConfidence} />}
                  </div>
                  <div className="grid gap-1.5">
                    <Label htmlFor="discountLabel">Discount label</Label>
                    <Input
                      id="discountLabel"
                      placeholder="Birthday voucher"
                      {...register("discountLabel")}
                    />
                  </div>
                </div>

                <div className="grid gap-1.5">
                  <Label htmlFor="declaredTotal">Receipt total (optional)</Label>
                  <Controller
                    name="declaredTotal"
                    control={control}
                    render={({ field }) => (
                      <AmountInput
                        id="declaredTotal"
                        placeholder="Leave blank to use the computed total"
                        value={field.value}
                        onChange={field.onChange}
                      />
                    )}
                  />
                  {parsed && <ConfidenceHint confidence={parsed.totalConfidence} />}
                  <p className="text-muted-foreground text-xs">
                    If what&apos;s printed on the receipt is a cent or two off from what these items
                    add up to, enter it here — the difference is recorded and split, never dropped.
                  </p>
                </div>

                <Button type="submit" className={cn("w-full")} disabled={isSubmitting}>
                  {isSubmitting ? "Creating bill…" : "Confirm & create bill"}
                </Button>
              </form>
            </>
          )}
        </div>
      </AppShell>
    </RequireAuth>
  );
}
