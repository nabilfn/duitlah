"use client";

import { useQuery } from "@tanstack/react-query";
import { CameraIcon, ReceiptTextIcon } from "lucide-react";
import Link from "next/link";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient } from "@/lib/api-client";
import { formatAmount, formatDate } from "@/lib/format";
import type { Bill } from "@/types/bagilah";
import { CreateBillDialog } from "./create-bill-dialog";

function statusVariant(status: Bill["status"]) {
  if (status === "FINALIZED") return "default" as const;
  if (status === "CANCELLED") return "outline" as const;
  return "secondary" as const;
}

export default function BagilahPage() {
  const { data: bills, isLoading } = useQuery({
    queryKey: ["bills"],
    queryFn: () => apiClient.get<Bill[]>("/api/v1/bills"),
  });

  const visibleBills = bills?.filter((b) => b.status !== "CANCELLED") ?? [];

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          <div className="flex items-center justify-between gap-4">
            <h1 className="text-2xl font-semibold tracking-tight">Bagilah</h1>
            <div className="flex gap-2">
              <Button variant="outline" nativeButton={false} render={<Link href="/bagilah/scan" />}>
                <CameraIcon className="size-4" />
                Scan receipt
              </Button>
              <CreateBillDialog />
            </div>
          </div>

          {isLoading && (
            <div className="space-y-3">
              {Array.from({ length: 2 }).map((_, i) => (
                <Skeleton key={i} className="h-16 w-full" />
              ))}
            </div>
          )}

          {visibleBills.length === 0 && !isLoading && (
            <EmptyState
              icon={ReceiptTextIcon}
              title="No bills yet."
              description="Start a bill, add what was ordered, and split it exactly — down to the cent."
              action={<CreateBillDialog />}
            />
          )}

          <div className="space-y-2">
            {visibleBills.map((bill) => (
              <Link key={bill.id} href={`/bagilah/${bill.id}`}>
                <Card>
                  <CardContent className="flex items-center justify-between">
                    <div>
                      <p className="text-sm font-medium">{bill.merchant || "Untitled bill"}</p>
                      <p className="text-muted-foreground text-xs">
                        {formatDate(bill.receiptDate)}
                      </p>
                    </div>
                    <div className="flex items-center gap-3">
                      {bill.total && (
                        <span className="font-amount text-sm font-semibold">
                          RM {formatAmount(bill.total)}
                        </span>
                      )}
                      <Badge variant={statusVariant(bill.status)}>{bill.status}</Badge>
                    </div>
                  </CardContent>
                </Card>
              </Link>
            ))}
          </div>
        </div>
      </AppShell>
    </RequireAuth>
  );
}
