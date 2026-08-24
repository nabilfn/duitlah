package com.duitlah.api.bagilah;

import java.util.UUID;

public record ItemIssueResponse(
    UUID itemId, String itemName, BagilahCalculationEngine.IssueType type) {}
