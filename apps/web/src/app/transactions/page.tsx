"use client";

import { useQuery } from "@tanstack/react-query";
import { ArrowLeftRightIcon, ReceiptTextIcon } from "lucide-react";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { Card, CardContent } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient } from "@/lib/api-client";
import { formatAmount, formatDate } from "@/lib/format";
import type { Account, Category, Page, Transaction } from "@/types/finance";
import { CreateTransactionDialog } from "./create-transaction-dialog";
import { CreateTransferDialog } from "./create-transfer-dialog";

export default function TransactionsPage() {
  const { data: accounts, isLoading: accountsLoading } = useQuery({
    queryKey: ["accounts"],
    queryFn: () => apiClient.get<Account[]>("/api/v1/accounts"),
  });
  const { data: categories } = useQuery({
    queryKey: ["categories"],
    queryFn: () => apiClient.get<Category[]>("/api/v1/categories"),
  });
  const { data: transactions, isLoading: transactionsLoading } = useQuery({
    queryKey: ["transactions"],
    queryFn: () => apiClient.get<Page<Transaction>>("/api/v1/transactions?size=100"),
  });

  const activeAccounts = accounts?.filter((a) => !a.archived) ?? [];
  const accountName = (id: string) => accounts?.find((a) => a.id === id)?.name ?? "Unknown account";
  const category = (id: string | null) => categories?.find((c) => c.id === id);

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          <div className="flex items-center justify-between gap-4">
            <h1 className="text-2xl font-semibold tracking-tight">Transactions</h1>
            {!accountsLoading && activeAccounts.length > 0 && (
              <div className="flex gap-2">
                <CreateTransferDialog accounts={activeAccounts} />
                <CreateTransactionDialog accounts={activeAccounts} />
              </div>
            )}
          </div>

          {!accountsLoading && activeAccounts.length === 0 && (
            <EmptyState
              icon={ReceiptTextIcon}
              title="Add an account first."
              description="Transactions belong to an account — set one up before recording income or expenses."
              action={
                <a href="/accounts" className="text-sm font-medium hover:underline">
                  Go to Accounts
                </a>
              }
            />
          )}

          {transactionsLoading && (
            <div className="space-y-2">
              {Array.from({ length: 4 }).map((_, i) => (
                <Skeleton key={i} className="h-14 w-full" />
              ))}
            </div>
          )}

          {transactions?.content.length === 0 && activeAccounts.length > 0 && (
            <EmptyState
              icon={ReceiptTextIcon}
              title="No transactions yet."
              description="Add your first expense and start seeing where your money goes."
            />
          )}

          <div className="space-y-2">
            {transactions?.content.map((t) => {
              const cat = category(t.categoryId);
              const isTransfer = t.type === "TRANSFER";
              const isIn = t.direction === "IN";
              return (
                <Card key={t.id}>
                  <CardContent className="flex items-center gap-3">
                    <div className="bg-muted flex size-9 shrink-0 items-center justify-center rounded-full text-base">
                      {isTransfer ? <ArrowLeftRightIcon className="size-4" /> : (cat?.icon ?? "💸")}
                    </div>
                    <div className="min-w-0 flex-1">
                      <p className="truncate text-sm font-medium">
                        {t.merchant ||
                          t.description ||
                          (isTransfer ? "Transfer" : cat?.name) ||
                          "Transaction"}
                      </p>
                      <p className="text-muted-foreground text-xs">
                        {accountName(t.accountId)} · {formatDate(t.occurredOn)}
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
      </AppShell>
    </RequireAuth>
  );
}
