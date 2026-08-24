export type SettlementStatus = "UNPAID" | "PARTIALLY_PAID" | "PAID" | "CANCELLED" | "DISPUTED";
export type SourceType = "BILL" | "GROUP";

export interface PaymentHandoffLink {
  provider: string;
  instructions: string;
  url: string | null;
}

export interface Settlement {
  id: string;
  fromUserId: string;
  fromDisplayName: string;
  toUserId: string;
  toDisplayName: string;
  amount: string;
  amountPaid: string;
  amountRemaining: string;
  status: SettlementStatus;
  sourceType: SourceType;
  sourceId: string;
  createdAt: string;
  handoff: PaymentHandoffLink;
}

export interface SettlementPayment {
  id: string;
  amount: string;
  recordedByUserId: string;
  recordedByDisplayName: string;
  note: string | null;
  paidAt: string;
}

export interface CounterpartySummary {
  userId: string;
  displayName: string;
  netAmount: string;
  oldestUnpaidDays: number;
}

export interface SettlementSummary {
  totalOwedToMe: string;
  totalIOwe: string;
  owedToMe: CounterpartySummary[];
  iOwe: CounterpartySummary[];
}
