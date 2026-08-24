import { z } from "zod";

const amount = z
  .string()
  .min(1, "Enter an amount")
  .refine((v) => !Number.isNaN(Number(v)) && Number(v) >= 0, "Enter a valid amount");

const positiveAmount = z
  .string()
  .min(1, "Enter an amount")
  .refine((v) => !Number.isNaN(Number(v)) && Number(v) > 0, "Enter an amount greater than 0");

export const confirmScanItemSchema = z.object({
  name: z.string().trim().min(1, "Enter a name").max(160),
  quantity: positiveAmount,
  unitPrice: amount,
});
export type ConfirmScanItemInput = z.infer<typeof confirmScanItemSchema>;

export const confirmScanSchema = z.object({
  merchant: z.string().trim().max(160).optional().or(z.literal("")),
  receiptDate: z.string().min(1, "Choose a date"),
  items: z.array(confirmScanItemSchema).min(1, "Add at least one item"),
  tax: amount,
  taxStrategy: z.enum(["PROPORTIONAL", "EQUAL"]),
  serviceCharge: amount,
  serviceStrategy: z.enum(["PROPORTIONAL", "EQUAL"]),
  discount: amount,
  discountLabel: z.string().trim().max(120).optional().or(z.literal("")),
  declaredTotal: z.string().optional().or(z.literal("")),
});
export type ConfirmScanInput = z.infer<typeof confirmScanSchema>;
