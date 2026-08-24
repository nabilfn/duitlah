"use client";

import { useQuery } from "@tanstack/react-query";
import { TargetIcon } from "lucide-react";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { ProgressBar } from "@/components/finance/progress-bar";
import { Card, CardContent } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient } from "@/lib/api-client";
import { formatAmount, formatDate } from "@/lib/format";
import { goalTypes } from "@/lib/validation/budget";
import type { Goal } from "@/types/budget";
import { AddContributionDialog } from "./add-contribution-dialog";
import { CreateGoalDialog } from "./create-goal-dialog";

function goalIcon(type: string) {
  return goalTypes.find((t) => t.value === type)?.icon ?? "🎯";
}

export default function GoalsPage() {
  const { data: goals, isLoading } = useQuery({
    queryKey: ["goals"],
    queryFn: () => apiClient.get<Goal[]>("/api/v1/goals"),
  });

  const activeGoals = goals?.filter((g) => !g.archived) ?? [];

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          <div className="flex items-center justify-between gap-4">
            <h1 className="text-2xl font-semibold tracking-tight">Goals</h1>
            <CreateGoalDialog />
          </div>

          {isLoading && (
            <div className="space-y-3">
              {Array.from({ length: 2 }).map((_, i) => (
                <Skeleton key={i} className="h-32 w-full" />
              ))}
            </div>
          )}

          {activeGoals.length === 0 && !isLoading && (
            <EmptyState
              icon={TargetIcon}
              title="No goals yet."
              description="Set a target — an emergency fund, a trip, a deposit — and track your progress toward it."
              action={<CreateGoalDialog />}
            />
          )}

          <div className="space-y-3">
            {activeGoals.map((goal) => {
              const percentage = Number(goal.percentage);
              const remaining = Number(goal.remaining);
              return (
                <Card key={goal.id}>
                  <CardContent className="space-y-3">
                    <div className="flex items-center justify-between">
                      <p className="text-sm font-medium">
                        {goalIcon(goal.type)} {goal.name}
                      </p>
                      {goal.targetDate && (
                        <p className="text-muted-foreground text-xs">
                          Target {formatDate(goal.targetDate)}
                        </p>
                      )}
                    </div>
                    <ProgressBar
                      percentage={percentage}
                      tone={percentage >= 100 ? "primary" : "primary"}
                    />
                    <div className="flex items-center justify-between text-sm">
                      <span className="font-amount">
                        RM {formatAmount(goal.currentAmount)} / RM {formatAmount(goal.targetAmount)}
                      </span>
                      <span className="text-muted-foreground">
                        {remaining > 0
                          ? `RM ${formatAmount(remaining)} to go`
                          : `Reached — RM ${formatAmount(Math.abs(remaining))} over`}
                      </span>
                    </div>
                    <AddContributionDialog goalId={goal.id} goalName={goal.name} />
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
