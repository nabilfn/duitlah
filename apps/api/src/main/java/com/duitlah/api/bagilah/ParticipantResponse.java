package com.duitlah.api.bagilah;

import java.util.UUID;

public record ParticipantResponse(UUID id, UUID userId, String displayName, boolean guest) {}
