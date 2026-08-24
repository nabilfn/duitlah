/**
 * A guest's session token, kept in sessionStorage rather than in-memory like the real access
 * token (see stores/auth-store.ts) -- a guest has no httpOnly refresh cookie to fall back on, so
 * losing it on an accidental reload would kick them out of an active claiming session entirely.
 * sessionStorage survives a reload but not a tab close or a different device, which is the right
 * scope for "this one device, this one bill-splitting session."
 */
export interface GuestSession {
  billId: string;
  participantId: string;
  guestToken: string;
  displayName: string;
}

function storageKey(billId: string): string {
  return `bagilah-guest-session:${billId}`;
}

export function saveGuestSession(session: GuestSession): void {
  sessionStorage.setItem(storageKey(session.billId), JSON.stringify(session));
}

export function loadGuestSession(billId: string): GuestSession | null {
  const raw = sessionStorage.getItem(storageKey(billId));
  if (!raw) return null;
  try {
    return JSON.parse(raw) as GuestSession;
  } catch {
    return null;
  }
}

export function clearGuestSession(billId: string): void {
  sessionStorage.removeItem(storageKey(billId));
}
