import { ApiRequestError, type ApiError } from "@/lib/api-client";
import { useAuthStore } from "@/stores/auth-store";
import type { ReceiptScan } from "@/types/receipt-scan";

const API_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8080";

/**
 * A one-off multipart upload, separate from `apiClient` because that client always
 * JSON-encodes its body — a `FormData` body needs the browser to set its own
 * multipart boundary `Content-Type`, which setting any header here would prevent.
 * Doesn't get the shared client's access-token refresh-and-retry treatment; an
 * acceptable simplification for a single user-initiated action (worst case: an
 * expired token surfaces a clear error the user can retry, rather than silently
 * refreshing mid-upload).
 */
export async function uploadReceiptScan(file: File): Promise<ReceiptScan> {
  const token = useAuthStore.getState().accessToken;
  const formData = new FormData();
  formData.append("image", file);

  const response = await fetch(`${API_URL}/api/v1/receipts/scans`, {
    method: "POST",
    headers: token ? { Authorization: `Bearer ${token}` } : {},
    body: formData,
    credentials: "include",
  });

  if (!response.ok) {
    const error: ApiError = await response
      .json()
      .catch(() => ({ code: "UNKNOWN_ERROR", message: response.statusText }));
    throw new ApiRequestError(response.status, error);
  }
  return response.json() as Promise<ReceiptScan>;
}
