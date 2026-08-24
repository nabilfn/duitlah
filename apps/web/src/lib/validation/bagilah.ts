import { z } from "zod";

const amount = z
  .string()
  .min(1, "Enter an amount")
  .refine((v) => !Number.isNaN(Number(v)) && Number(v) >= 0, "Enter a valid amount");

const positiveAmount = z
  .string()
  .min(1, "Enter an amount")
  .refine((v) => !Number.isNaN(Number(v)) && Number(v) > 0, "Enter an amount greater than 0");

export const createBillSchema = z.object({
  merchant: z.string().trim().max(160).optional().or(z.literal("")),
  receiptDate: z.string().min(1, "Choose a date"),
});
export type CreateBillInput = z.infer<typeof createBillSchema>;

export const addItemSchema = z.object({
  name: z.string().trim().min(1, "Enter a name").max(160),
  quantity: positiveAmount,
  unitPrice: amount,
  itemDiscount: amount.optional().or(z.literal("")),
});
export type AddItemInput = z.infer<typeof addItemSchema>;

export const addParticipantSchema = z
  .object({
    userId: z.string().optional(),
    guestName: z.string().trim().max(120).optional().or(z.literal("")),
  })
  .refine((v) => Boolean(v.userId) !== Boolean(v.guestName), {
    message: "Provide either an existing user or a guest name, not both.",
    path: ["guestName"],
  });
export type AddParticipantInput = z.infer<typeof addParticipantSchema>;

export const recordPaymentSchema = z.object({
  amountPaid: positiveAmount,
});
export type RecordPaymentInput = z.infer<typeof recordPaymentSchema>;

export const updateBillChargesSchema = z.object({
  tax: amount,
  taxStrategy: z.enum(["PROPORTIONAL", "EQUAL"]),
  serviceCharge: amount,
  serviceStrategy: z.enum(["PROPORTIONAL", "EQUAL"]),
  discount: amount,
  discountLabel: z.string().trim().max(120).optional().or(z.literal("")),
  declaredTotal: z.string().optional().or(z.literal("")),
});
export type UpdateBillChargesInput = z.infer<typeof updateBillChargesSchema>;
