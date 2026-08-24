export type BillStatus = "DRAFT" | "FINALIZED" | "CANCELLED";
export type AllocationStrategy = "PROPORTIONAL" | "EQUAL";
export type ClaimType = "QUANTITY" | "PERCENTAGE" | "AMOUNT";
export type IssueType = "UNCLAIMED" | "OVERALLOCATED" | "MIXED_CLAIM_TYPES";

export interface Bill {
  id: string;
  ownerUserId: string;
  groupId: string | null;
  merchant: string | null;
  receiptDate: string;
  currency: string;
  tax: string;
  taxStrategy: AllocationStrategy;
  serviceCharge: string;
  serviceStrategy: AllocationStrategy;
  discount: string;
  discountLabel: string | null;
  declaredTotal: string | null;
  total: string | null;
  roundingAdjustment: string | null;
  status: BillStatus;
  finalizedAt: string | null;
}

export interface ReceiptItem {
  id: string;
  name: string;
  quantity: string;
  unitPrice: string;
  itemDiscount: string;
  totalPrice: string;
}

export interface Participant {
  id: string;
  userId: string | null;
  displayName: string;
  guest: boolean;
}

export interface Claim {
  id: string;
  participantId: string;
  displayName: string;
  claimType: ClaimType;
  value: string;
}

export interface Payment {
  participantId: string;
  displayName: string;
  amountPaid: string;
}

export interface ItemIssue {
  itemId: string;
  itemName: string;
  type: IssueType;
}

export interface ParticipantBreakdown {
  participantId: string;
  displayName: string;
  subtotal: string;
  taxShare: string;
  serviceShare: string;
  discountShare: string;
  roundingShare: string;
  finalAmount: string;
}

export interface Breakdown {
  valid: boolean;
  issues: ItemIssue[];
  subtotal: string;
  computedTotal: string;
  roundingAdjustment: string;
  participants: ParticipantBreakdown[];
}

export interface BillBalance {
  participantId: string;
  displayName: string;
  paid: string;
  owed: string;
  net: string;
}

export interface JoinBillResponse {
  billId: string;
  participantId: string;
  displayName: string;
  guest: boolean;
  guestToken: string | null;
}
