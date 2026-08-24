"use client";

import { useQuery } from "@tanstack/react-query";
import { WalletIcon } from "lucide-react";
import { RequireAuth } from "@/components/auth/require-auth";
import { AppShell } from "@/components/nav/app-shell";
import { Card, CardContent } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";
import { Skeleton } from "@/components/ui/skeleton";
import { apiClient } from "@/lib/api-client";
import { formatAmount } from "@/lib/format";
import { accountTypes } from "@/lib/validation/finance";
import type { Account } from "@/types/finance";
import { CreateAccountDialog } from "./create-account-dialog";

function accountTypeLabel(type: string) {
  return accountTypes.find((t) => t.value === type)?.label ?? type;
}

export default function AccountsPage() {
  const { data: accounts, isLoading } = useQuery({
    queryKey: ["accounts"],
    queryFn: () => apiClient.get<Account[]>("/api/v1/accounts"),
  });

  return (
    <RequireAuth>
      <AppShell>
        <div className="mx-auto max-w-2xl space-y-6 px-4 py-8 md:px-8 md:py-10">
          <div className="flex items-center justify-between gap-4">
            <h1 className="text-2xl font-semibold tracking-tight">Accounts</h1>
            <CreateAccountDialog />
          </div>

          {isLoading && (
            <div className="space-y-3">
              {Array.from({ length: 3 }).map((_, i) => (
                <Skeleton key={i} className="h-20 w-full" />
              ))}
            </div>
          )}

          {accounts?.length === 0 && (
            <EmptyState
              icon={WalletIcon}
              title="No accounts yet."
              description="Add your bank, e-wallet, or cash on hand to start tracking your money."
              action={<CreateAccountDialog />}
            />
          )}

          <div className="space-y-3">
            {accounts
              ?.filter((a) => !a.archived)
              .map((account) => (
                <Card key={account.id}>
                  <CardContent className="flex items-center justify-between">
                    <div>
                      <p className="text-sm font-medium">{account.name}</p>
                      <p className="text-muted-foreground text-xs">
                        {accountTypeLabel(account.type)} · {account.currency}
                      </p>
                    </div>
                    <p className="font-amount text-sm font-semibold">
                      RM {formatAmount(account.balance)}
                    </p>
                  </CardContent>
                </Card>
              ))}
          </div>
        </div>
      </AppShell>
    </RequireAuth>
  );
}
