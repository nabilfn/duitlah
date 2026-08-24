export type GroupType =
  "GENERAL" | "HOUSEMATES" | "COUPLE" | "TRIP" | "FRIENDS" | "FAMILY" | "TEAM" | "EVENT";
export type GroupMemberRole = "OWNER" | "MEMBER";

export interface Group {
  id: string;
  name: string;
  type: GroupType;
  yourRole: GroupMemberRole;
  memberCount: number;
  archived: boolean;
}

export interface GroupMember {
  userId: string;
  displayName: string;
  email: string;
  role: GroupMemberRole;
  joinedAt: string;
}

export interface GroupExpenseShare {
  userId: string;
  displayName: string;
  amount: string;
}

export interface GroupExpense {
  id: string;
  description: string;
  amount: string;
  occurredOn: string;
  paidByUserId: string;
  paidByName: string;
  shares: GroupExpenseShare[];
}

export interface GroupBalance {
  userId: string;
  displayName: string;
  totalPaid: string;
  totalShare: string;
  net: string;
}
