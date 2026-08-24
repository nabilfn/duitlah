"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { ReceiptTextIcon } from "lucide-react";
import { use } from "react";
import { toast } from "sonner";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient, ApiRequestError } from "@/lib/api-client";
import { formatAmount, formatDate } from "@/lib/format";
import { groupTypes } from "@/lib/validation/group";
import type { Group, GroupBalance, GroupExpense, GroupMember } from "@/types/group";
import type { Settlement } from "@/types/settlement";
import { CreateExpenseDialog } from "./create-expense-dialog";
import { InviteDialog } from "./invite-dialog";

function groupIcon(type: string) {
  return groupTypes.find((t) => t.value === type)?.icon ?? "👥";
}

export default function GroupDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id: groupId } = use(params);
  const queryClient = useQueryClient();

  const { data: group, isLoading: groupLoading } = useQuery({
    queryKey: ["group", groupId],
    queryFn: () => apiClient.get<Group>(`/api/v1/groups/${groupId}`),
  });
  const { data: members } = useQuery({
    queryKey: ["group-members", groupId],
    queryFn: () => apiClient.get<GroupMember[]>(`/api/v1/groups/${groupId}/members`),
  });
  const { data: balances } = useQuery({
    queryKey: ["group-balances", groupId],
    queryFn: () => apiClient.get<GroupBalance[]>(`/api/v1/groups/${groupId}/balances`),
  });
  const { data: expenses, isLoading: expensesLoading } = useQuery({
    queryKey: ["group-expenses", groupId],
    queryFn: () => apiClient.get<GroupExpense[]>(`/api/v1/groups/${groupId}/expenses`),
  });

  const settleMutation = useMutation({
    mutationFn: () => apiClient.post<Settlement[]>(`/api/v1/groups/${groupId}/settle`),
    onSuccess: (created) => {
      queryClient.invalidateQueries({ queryKey: ["group-balances", groupId] });
      queryClient.invalidateQueries({ queryKey: ["settlements"] });
      queryClient.invalidateQueries({ queryKey: ["settlements-summary"] });
      toast.success(
        created.length === 0
          ? "Everyone's already settled up."
          : `${created.length} settlement${created.length === 1 ? "" : "s"} created — see Settlements.`,
      );
    },
    onError: (error) => {
      toast.error(error instanceof ApiRequestError ? error.error.message : "Something went wrong.");
    },
  });

  const hasOutstandingBalance = balances?.some((b) => Number(b.net) !== 0) ?? false;

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          {groupLoading && <Skeleton className="h-10 w-48" />}

          {group && (
            <div className="flex items-center justify-between gap-4">
              <div>
                <h1 className="text-2xl font-semibold tracking-tight">
                  {groupIcon(group.type)} {group.name}
                </h1>
                <p className="text-muted-foreground text-sm">
                  {group.memberCount} {group.memberCount === 1 ? "member" : "members"}
                </p>
              </div>
              <InviteDialog groupId={groupId} />
            </div>
          )}

          {members && members.length > 0 && (
            <div className="flex -space-x-2">
              {members.map((m) => (
                <Avatar key={m.userId} className="border-background border-2">
                  <AvatarFallback>{m.displayName.charAt(0)}</AvatarFallback>
                </Avatar>
              ))}
            </div>
          )}

          {balances && balances.length > 0 && (
            <Card>
              <CardContent className="space-y-2">
                <div className="flex items-center justify-between">
                  <p className="text-sm font-medium">Balances</p>
                  {group?.yourRole === "OWNER" && hasOutstandingBalance && (
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={() => settleMutation.mutate()}
                      disabled={settleMutation.isPending}
                    >
                      {settleMutation.isPending ? "Settling…" : "Settle up"}
                    </Button>
                  )}
                </div>
                {balances.map((b) => (
                  <div key={b.userId} className="flex items-center justify-between text-sm">
                    <span>{b.displayName}</span>
                    <span
                      className={
                        Number(b.net) > 0
                          ? "text-success"
                          : Number(b.net) < 0
                            ? "text-destructive"
                            : ""
                      }
                    >
                      {Number(b.net) > 0
                        ? `Owed RM ${formatAmount(b.net)}`
                        : Number(b.net) < 0
                          ? `Owes RM ${formatAmount(Math.abs(Number(b.net)))}`
                          : "Settled up"}
                    </span>
                  </div>
                ))}
              </CardContent>
            </Card>
          )}

          <div>
            <div className="mb-2 flex items-center justify-between">
              <h2 className="text-sm font-medium">Expenses</h2>
              {members && <CreateExpenseDialog groupId={groupId} members={members} />}
            </div>

            {expensesLoading && (
              <div className="space-y-2">
                {Array.from({ length: 2 }).map((_, i) => (
                  <Skeleton key={i} className="h-16 w-full" />
                ))}
              </div>
            )}

            {expenses?.length === 0 && (
              <EmptyState
                icon={ReceiptTextIcon}
                title="No shared expenses yet."
                description="Log the first one — everyone will see exactly how it's split."
              />
            )}

            <div className="space-y-2">
              {expenses?.map((expense) => (
                <Card key={expense.id}>
                  <CardContent className="space-y-1">
                    <div className="flex items-center justify-between">
                      <p className="text-sm font-medium">{expense.description}</p>
                      <p className="font-amount text-sm font-semibold">
                        RM {formatAmount(expense.amount)}
                      </p>
                    </div>
                    <p className="text-muted-foreground text-xs">
                      {expense.paidByName} paid · {formatDate(expense.occurredOn)} · split{" "}
                      {expense.shares.length} ways
                    </p>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        </div>
      </AppShell>
    </RequireAuth>
  );
}
