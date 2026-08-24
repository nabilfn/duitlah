export type ScanStatus = "PARSED" | "FAILED" | "CONFIRMED";

export interface ParsedReceiptItem {
  name: string | null;
  quantity: string | null;
  unitPrice: string | null;
  totalPrice: string | null;
  confidence: number;
}

export interface ParsedReceipt {
  merchant: string | null;
  merchantConfidence: number;
  receiptDate: string | null;
  receiptDateConfidence: number;
  items: ParsedReceiptItem[];
  tax: string | null;
  taxConfidence: number;
  serviceCharge: string | null;
  serviceConfidence: number;
  discount: string | null;
  discountConfidence: number;
  total: string | null;
  totalConfidence: number;
  overallConfidence: number;
}

export interface ReceiptScan {
  id: string;
  status: ScanStatus;
  provider: string;
  overallConfidence: number | null;
  parsedReceipt: ParsedReceipt;
  imageUrl: string;
  errorMessage: string | null;
  billId: string | null;
}
