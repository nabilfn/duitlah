export type AccountType =
  "CASH" | "BANK" | "E_WALLET" | "CREDIT_CARD" | "SAVINGS" | "INVESTMENT" | "OTHER";

export interface Account {
  id: string;
  name: string;
  type: AccountType;
  currency: string;
  openingBalance: string;
  balance: string;
  archived: boolean;
}

export type CategoryType = "INCOME" | "EXPENSE";

export interface Category {
  id: string;
  parentId: string | null;
  type: CategoryType;
  name: string;
  icon: string | null;
  custom: boolean;
}

export type TransactionType = "INCOME" | "EXPENSE" | "TRANSFER";
export type TransactionDirection = "IN" | "OUT";

export interface Transaction {
  id: string;
  accountId: string;
  type: TransactionType;
  direction: TransactionDirection;
  categoryId: string | null;
  transferGroupId: string | null;
  amount: string;
  merchant: string | null;
  description: string | null;
  notes: string | null;
  occurredOn: string;
}

export interface Page<T> {
  content: T[];
  totalElements: number;
  totalPages: number;
  number: number;
  size: number;
}

export interface DashboardSummary {
  availableBalance: string;
  monthIncome: string;
  monthExpense: string;
  recentTransactions: Transaction[];
}
