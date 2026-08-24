import { useEffect } from "react";

const API_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8080";

/**
 * Live updates for a bill (product spec section 66) -- "Ameer joined," "Ameer claimed Chicken
 * Chop" -- without polling. Uses `fetch` with a streamed body rather than the native
 * `EventSource` API: EventSource can't attach an `Authorization` header, and the owner/participant
 * events endpoint is a normal bearer-token route, so putting the JWT in the URL instead (the usual
 * EventSource workaround) would leak it into browser history and server logs. The guest events
 * endpoint doesn't have this problem -- its token is already part of every guest URL -- so this
 * same hook covers both by just taking whatever path and (optional) token it's given.
 *
 * This intentionally doesn't parse individual event payloads; every event just triggers
 * `onEvent`, which the caller uses to invalidate the relevant queries. For a handful of
 * participants on one small bill, refetching everything on any change is simpler than maintaining
 * a fine-grained event contract and cheap enough not to matter.
 */
export function useBillEvents(
  path: string | null,
  accessToken: string | null,
  onEvent: () => void,
) {
  useEffect(() => {
    if (!path) return;
    const controller = new AbortController();
    let cancelled = false;

    async function connect() {
      try {
        const response = await fetch(`${API_URL}${path}`, {
          headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : {},
          signal: controller.signal,
        });
        const reader = response.body?.getReader();
        if (!reader) return;
        const decoder = new TextDecoder();
        let buffer = "";
        while (!cancelled) {
          const { done, value } = await reader.read();
          if (done) break;
          buffer += decoder.decode(value, { stream: true });
          const messages = buffer.split("\n\n");
          buffer = messages.pop() ?? "";
          for (const message of messages) {
            if (message.trim().length > 0) {
              onEvent();
            }
          }
        }
      } catch {
        // Connection dropped or was aborted on unmount -- the next manual refetch or
        // reconnect picks up whatever changed; nothing to surface to the user for this.
      }
    }

    connect();
    return () => {
      cancelled = true;
      controller.abort();
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [path, accessToken]);
}
