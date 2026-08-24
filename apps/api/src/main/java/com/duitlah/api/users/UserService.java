package com.duitlah.api.users;

import com.duitlah.api.audit.AuditAction;
import com.duitlah.api.audit.AuditLogService;
import java.util.Map;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

  private final UserRepository users;
  private final AuditLogService auditLogService;

  public UserService(UserRepository users, AuditLogService auditLogService) {
    this.users = users;
    this.auditLogService = auditLogService;
  }

  public User getById(UUID userId) {
    return users.findById(userId).orElseThrow();
  }

  @Transactional
  public User updateProfile(UUID userId, UpdateProfileRequest request) {
    User user = getById(userId);
    user.setDisplayName(request.displayName().trim());
    users.save(user);
    auditLogService.record(
        userId,
        AuditAction.ACCOUNT_INFO_CHANGED,
        "User",
        userId,
        Map.of("displayName", user.getDisplayName()));
    return user;
  }
}
