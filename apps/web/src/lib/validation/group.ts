import { z } from "zod";

export const groupTypes = [
  { value: "GENERAL", label: "General", icon: "👥" },
  { value: "HOUSEMATES", label: "Housemates", icon: "🏠" },
  { value: "COUPLE", label: "Couple", icon: "💑" },
  { value: "TRIP", label: "Trip", icon: "✈️" },
  { value: "FRIENDS", label: "Friends", icon: "🎉" },
  { value: "FAMILY", label: "Family", icon: "👨‍👩‍👧" },
  { value: "TEAM", label: "Team", icon: "🧑‍💻" },
  { value: "EVENT", label: "Event", icon: "🎊" },
] as const;

export const createGroupSchema = z.object({
  name: z.string().trim().min(1, "Enter a name").max(120),
  type: z.enum(["GENERAL", "HOUSEMATES", "COUPLE", "TRIP", "FRIENDS", "FAMILY", "TEAM", "EVENT"]),
});
export type CreateGroupInput = z.infer<typeof createGroupSchema>;

const amount = z
  .string()
  .min(1, "Enter an amount")
  .refine((v) => !Number.isNaN(Number(v)) && Number(v) > 0, "Enter an amount greater than 0");

export const createGroupExpenseSchema = z.object({
  description: z.string().trim().min(1, "Enter a description").max(255),
  amount,
  occurredOn: z.string().min(1, "Choose a date"),
  paidByUserId: z.string().optional(),
});
export type CreateGroupExpenseInput = z.infer<typeof createGroupExpenseSchema>;

export const joinGroupSchema = z.object({
  token: z.string().trim().min(1, "Paste an invite link or code"),
});
export type JoinGroupInput = z.infer<typeof joinGroupSchema>;
