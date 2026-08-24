/** Accepts either a full invite URL (?token=...) or a bare token pasted directly. */
export function extractBagilahInviteToken(input: string): string {
  const trimmed = input.trim();
  try {
    const url = new URL(trimmed);
    return url.searchParams.get("token") ?? trimmed;
  } catch {
    return trimmed;
  }
}

export function buildBagilahInviteUrl(token: string): string {
  const origin = typeof window !== "undefined" ? window.location.origin : "";
  return `${origin}/bagilah/join?token=${token}`;
}
