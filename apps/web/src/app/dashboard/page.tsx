"use client";

import { useQuery } from "@tanstack/react-query";
import { ArrowLeftRightIcon, ReceiptTextIcon } from "lucide-react";
import Link from "next/link";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { BalanceCard } from "@/components/finance/balance-card";
import { Card, CardContent } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient } from "@/lib/api-client";
import { formatAmount, formatDate } from "@/lib/format";
import { useAuthStore } from "@/stores/auth-store";
import type { DashboardSummary } from "@/types/finance";

export default function Home() {
  const user = useAuthStore((state) => state.user);
  const status = useAuthStore((state) => state.status);
  const { data, isLoading } = useQuery({
    queryKey: ["dashboard"],
    queryFn: () => apiClient.get<DashboardSummary>("/api/v1/dashboard"),
    // `RequireAuth` below only gates rendering, not this hook -- without `enabled`, this fires
    // immediately on mount even for a signed-out visitor, before RequireAuth's own redirect has
    // a chance to run.
    enabled: status === "authenticated",
  });

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          <div>
            <h1 className="text-2xl font-semibold tracking-tight">
              {user ? `Good to see you, ${user.displayName}` : "Home"}
            </h1>
          </div>

          {isLoading && <Skeleton className="h-32 w-full rounded-2xl" />}

          {data && (
            <>
              <BalanceCard
                label="Available balance"
                amount={formatAmount(data.availableBalance)}
                meta={
                  <span>
                    This month: +RM {formatAmount(data.monthIncome)} · -RM{" "}
                    {formatAmount(data.monthExpense)}
                  </span>
                }
              />
              <Link
                href="/accounts"
                className="text-muted-foreground -mt-3 block text-xs hover:underline"
              >
                Manage accounts
              </Link>

              <div>
                <div className="mb-2 flex items-center justify-between">
                  <h2 className="text-sm font-medium">Recent transactions</h2>
                  <Link
                    href="/transactions"
                    className="text-muted-foreground text-xs hover:underline"
                  >
                    View all
                  </Link>
                </div>

                {data.recentTransactions.length === 0 && (
                  <EmptyState
                    icon={ReceiptTextIcon}
                    title="No transactions yet."
                    description="Add your first expense and start seeing where your money goes."
                  />
                )}

                <div className="space-y-2">
                  {data.recentTransactions.map((t) => {
                    const isIn = t.direction === "IN";
                    return (
                      <Card key={t.id}>
                        <CardContent className="flex items-center gap-3">
                          <div className="bg-muted flex size-9 shrink-0 items-center justify-center rounded-full">
                            {t.type === "TRANSFER" ? (
                              <ArrowLeftRightIcon className="size-4" />
                            ) : (
                              "💸"
                            )}
                          </div>
                          <div className="min-w-0 flex-1">
                            <p className="truncate text-sm font-medium">
                              {t.merchant || t.description || t.type}
                            </p>
                            <p className="text-muted-foreground text-xs">
                              {formatDate(t.occurredOn)}
                            </p>
                          </div>
                          <p
                            className={`font-amount shrink-0 text-sm font-semibold ${isIn ? "text-success" : ""}`}
                          >
                            {isIn ? "+" : "-"}RM {formatAmount(t.amount)}
                          </p>
                        </CardContent>
                      </Card>
                    );
                  })}
                </div>
              </div>
            </>
          )}
        </div>
      </AppShell>
    </RequireAuth>
  );
}
