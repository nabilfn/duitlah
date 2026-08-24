package com.duitlah.api.bizexpenses;

import java.util.UUID;

/** {@code chartOfAccountsId} may be null to clear an existing mapping. */
public record ChartOfAccountsMappingRequest(UUID chartOfAccountsId) {}
