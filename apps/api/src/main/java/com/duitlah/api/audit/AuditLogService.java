package com.duitlah.api.audit;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Map;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * Records the actions the product spec calls out in section 50. Callers pass whatever context is
 * useful for that specific action as {@code metadata} -- this class has no way to know what's
 * sensitive for a given action, so it's on each call site to follow the spec's "avoid logging
 * highly sensitive information unnecessarily" rule itself (never a raw password, token, or full
 * card/bank number; a merchant name or an amount is fine).
 *
 * <p>{@code record} deliberately never throws: a broken audit write must never take down the real
 * business operation it's describing. It participates in the caller's ambient transaction like any
 * other save in this codebase (not a separate transaction), so an audit row only actually persists
 * if the surrounding business change does too -- an audit log for something that didn't happen
 * would be worse than no log at all.
 */
@Service
public class AuditLogService {

  private static final Logger log = LoggerFactory.getLogger(AuditLogService.class);

  private final AuditLogRepository logs;
  private final ObjectMapper objectMapper = new ObjectMapper();

  public AuditLogService(AuditLogRepository logs) {
    this.logs = logs;
  }

  public void record(
      UUID actorUserId,
      AuditAction action,
      String entityType,
      UUID entityId,
      Map<String, Object> metadata) {
    try {
      String encodedMetadata =
          metadata == null || metadata.isEmpty() ? null : objectMapper.writeValueAsString(metadata);
      logs.save(new AuditLog(actorUserId, action, entityType, entityId, encodedMetadata));
    } catch (Exception e) {
      log.warn(
          "Failed to write audit log for {} on {}:{} -- continuing without it.",
          action,
          entityType,
          entityId,
          e);
    }
  }
}
