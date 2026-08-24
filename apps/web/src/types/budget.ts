export type BudgetStatus = "OK" | "WARNING" | "EXCEEDED";

export interface Budget {
  id: string;
  categoryId: string | null;
  categoryName: string;
  periodYear: number;
  periodMonth: number;
  limit: string;
  spent: string;
  remaining: string;
  status: BudgetStatus;
}

export type GoalType =
  | "EMERGENCY_FUND"
  | "TRAVEL"
  | "DEVICE"
  | "HOUSE_DEPOSIT"
  | "CAR"
  | "EDUCATION"
  | "WEDDING"
  | "CUSTOM";

export interface Goal {
  id: string;
  name: string;
  type: GoalType;
  targetAmount: string;
  targetDate: string | null;
  currentAmount: string;
  remaining: string;
  percentage: string;
  archived: boolean;
}

export interface GoalContribution {
  id: string;
  amount: string;
  occurredOn: string;
  note: string | null;
}
