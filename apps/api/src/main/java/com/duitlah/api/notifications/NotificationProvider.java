package com.duitlah.api.notifications;

import java.util.UUID;

/**
 * The provider abstraction spec section 24 asks for. {@link NotificationService} fans a single
 * {@code notify} call out to every bean implementing this interface — a new delivery channel is
 * just a new implementation, never a change to any caller.
 */
public interface NotificationProvider {

  void send(UUID userId, String type, String title, String body);
}
