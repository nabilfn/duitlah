/**
 * Financial Spaces (Duitlah V2, Phase 1) -- one Duitlah identity, multiple financial contexts.
 * Every user has exactly one PERSONAL space (created automatically at registration, or backfilled
 * for existing users by V16); a user may additionally own or be invited into any number of BUSINESS
 * spaces. This module is the one place space membership and role are resolved -- every future
 * Business-domain module depends on it for authorization, the same way every controller today
 * depends on {@code JwtAuthenticationFilter} for identity.
 *
 * <p>Module boundary: code outside this package should depend only on this module's public
 * service/DTO surface, not its internal classes.
 */
package com.duitlah.api.spaces;
