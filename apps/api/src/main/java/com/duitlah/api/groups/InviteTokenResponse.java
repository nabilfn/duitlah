package com.duitlah.api.groups;

/**
 * The raw token — the only place it exists outside a hash. Shown once; regenerate to reveal it
 * again.
 */
public record InviteTokenResponse(String token) {}
