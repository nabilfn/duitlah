package com.duitlah.api.spaces;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * The invitee must already have a Duitlah account (found by email) — a deliberate simplification
 * over a pending-email-invite system with a token nobody has wired real delivery for yet; adding
 * that is a real, separate feature to build later, not something to fake here.
 */
public record AddSpaceMemberRequest(@NotBlank @Email String email, @NotNull SpaceRole role) {}
