import { z } from "zod";

const amount = z
  .string()
  .min(1, "Enter an amount")
  .refine((v) => !Number.isNaN(Number(v)) && Number(v) > 0, "Enter an amount greater than 0");

export const accountTypes = [
  { value: "CASH", label: "Cash" },
  { value: "BANK", label: "Bank" },
  { value: "E_WALLET", label: "E-Wallet" },
  { value: "CREDIT_CARD", label: "Credit Card" },
  { value: "SAVINGS", label: "Savings" },
  { value: "INVESTMENT", label: "Investment" },
  { value: "OTHER", label: "Other" },
] as const;

export const createAccountSchema = z.object({
  name: z.string().trim().min(1, "Enter a name").max(120),
  type: z.enum(["CASH", "BANK", "E_WALLET", "CREDIT_CARD", "SAVINGS", "INVESTMENT", "OTHER"]),
  openingBalance: amount,
});
export type CreateAccountInput = z.infer<typeof createAccountSchema>;

export const createTransactionSchema = z.object({
  accountId: z.string().min(1, "Choose an account"),
  type: z.enum(["INCOME", "EXPENSE"]),
  categoryId: z.string().optional(),
  amount,
  merchant: z.string().max(120).optional(),
  description: z.string().max(255).optional(),
  occurredOn: z.string().min(1, "Choose a date"),
});
export type CreateTransactionInput = z.infer<typeof createTransactionSchema>;

export const createTransferSchema = z
  .object({
    fromAccountId: z.string().min(1, "Choose an account"),
    toAccountId: z.string().min(1, "Choose an account"),
    amount,
    occurredOn: z.string().min(1, "Choose a date"),
  })
  .refine((v) => v.fromAccountId !== v.toAccountId, {
    message: "Choose two different accounts",
    path: ["toAccountId"],
  });
export type CreateTransferInput = z.infer<typeof createTransferSchema>;
