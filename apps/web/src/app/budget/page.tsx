"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { PiggyBankIcon, XIcon } from "lucide-react";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { ProgressBar } from "@/components/finance/progress-bar";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient } from "@/lib/api-client";
import { formatAmount } from "@/lib/format";
import type { Budget } from "@/types/budget";
import { CreateBudgetDialog } from "./create-budget-dialog";

const STATUS_COPY: Record<Budget["status"], string> = {
  OK: "on track",
  WARNING: "getting close",
  EXCEEDED: "over budget",
};

export default function BudgetPage() {
  const queryClient = useQueryClient();
  const today = new Date();
  const periodYear = today.getFullYear();
  const periodMonth = today.getMonth() + 1;

  const { data: budgets, isLoading } = useQuery({
    queryKey: ["budgets", periodYear, periodMonth],
    queryFn: () =>
      apiClient.get<Budget[]>(`/api/v1/budgets?year=${periodYear}&month=${periodMonth}`),
  });

  const deleteMutation = useMutation({
    mutationFn: (id: string) => apiClient.delete(`/api/v1/budgets/${id}`),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["budgets"] }),
  });

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          <div className="flex items-center justify-between gap-4">
            <div>
              <h1 className="text-2xl font-semibold tracking-tight">Budget</h1>
              <p className="text-muted-foreground text-sm">
                {today.toLocaleDateString("en-MY", { month: "long", year: "numeric" })}
              </p>
            </div>
            <CreateBudgetDialog periodYear={periodYear} periodMonth={periodMonth} />
          </div>

          {isLoading && (
            <div className="space-y-3">
              {Array.from({ length: 3 }).map((_, i) => (
                <Skeleton key={i} className="h-24 w-full" />
              ))}
            </div>
          )}

          {budgets?.length === 0 && (
            <EmptyState
              icon={PiggyBankIcon}
              title="No budgets set for this month."
              description="Set an overall limit or a category limit — you'll see exactly where you stand as you spend."
              action={<CreateBudgetDialog periodYear={periodYear} periodMonth={periodMonth} />}
            />
          )}

          <div className="space-y-3">
            {budgets?.map((budget) => {
              const tone =
                budget.status === "EXCEEDED"
                  ? "destructive"
                  : budget.status === "WARNING"
                    ? "warning"
                    : "primary";
              const percentage = (Number(budget.spent) / Number(budget.limit)) * 100;
              const remaining = Number(budget.remaining);
              return (
                <Card key={budget.id}>
                  <CardContent className="space-y-2">
                    <div className="flex items-center justify-between">
                      <p className="text-sm font-medium">{budget.categoryName}</p>
                      <Button
                        variant="ghost"
                        size="icon-sm"
                        aria-label="Delete budget"
                        onClick={() => deleteMutation.mutate(budget.id)}
                      >
                        <XIcon />
                      </Button>
                    </div>
                    <ProgressBar percentage={percentage} tone={tone} />
                    <div className="flex items-center justify-between text-sm">
                      <span className="font-amount">
                        RM {formatAmount(budget.spent)} / RM {formatAmount(budget.limit)}
                      </span>
                      <span
                        className={
                          budget.status === "EXCEEDED"
                            ? "text-destructive"
                            : "text-muted-foreground"
                        }
                      >
                        {remaining >= 0
                          ? `RM ${formatAmount(remaining)} remaining`
                          : `RM ${formatAmount(Math.abs(remaining))} over — ${STATUS_COPY[budget.status]}`}
                      </span>
                    </div>
                  </CardContent>
                </Card>
              );
            })}
          </div>
        </div>
      </AppShell>
    </RequireAuth>
  );
}
