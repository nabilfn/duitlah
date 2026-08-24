import { z } from "zod";

const amount = z
  .string()
  .min(1, "Enter an amount")
  .refine((v) => !Number.isNaN(Number(v)) && Number(v) > 0, "Enter an amount greater than 0");

export const createBudgetSchema = z.object({
  categoryId: z.string().optional(),
  amountLimit: amount,
});
export type CreateBudgetInput = z.infer<typeof createBudgetSchema>;

export const goalTypes = [
  { value: "EMERGENCY_FUND", label: "Emergency Fund", icon: "🛟" },
  { value: "TRAVEL", label: "Travel", icon: "✈️" },
  { value: "DEVICE", label: "Device", icon: "💻" },
  { value: "HOUSE_DEPOSIT", label: "House Deposit", icon: "🏠" },
  { value: "CAR", label: "Car", icon: "🚗" },
  { value: "EDUCATION", label: "Education", icon: "🎓" },
  { value: "WEDDING", label: "Wedding", icon: "💍" },
  { value: "CUSTOM", label: "Custom", icon: "🎯" },
] as const;

export const createGoalSchema = z.object({
  name: z.string().trim().min(1, "Enter a name").max(120),
  type: z.enum([
    "EMERGENCY_FUND",
    "TRAVEL",
    "DEVICE",
    "HOUSE_DEPOSIT",
    "CAR",
    "EDUCATION",
    "WEDDING",
    "CUSTOM",
  ]),
  targetAmount: amount,
  targetDate: z.string().optional(),
});
export type CreateGoalInput = z.infer<typeof createGoalSchema>;

export const addContributionSchema = z.object({
  amount: z
    .string()
    .min(1, "Enter an amount")
    .refine((v) => !Number.isNaN(Number(v)) && Number(v) !== 0, "Enter a non-zero amount"),
  occurredOn: z.string().min(1, "Choose a date"),
  note: z.string().max(255).optional(),
});
export type AddContributionInput = z.infer<typeof addContributionSchema>;
