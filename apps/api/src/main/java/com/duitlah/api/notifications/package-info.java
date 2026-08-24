/**
 * In-app, push, and email notifications (V2 Phase 3, spec section 24 — replacing the Phase 9.5
 * placeholder screen with a real architecture). {@link
 * com.duitlah.api.notifications.NotificationService#notify} fans out to every {@link
 * com.duitlah.api.notifications.NotificationProvider} bean: {@link
 * com.duitlah.api.notifications.InAppNotificationProvider} (real, persisted) and {@link
 * com.duitlah.api.notifications.EmailNotificationProvider} (real, via {@code common.mail}) are
 * active today; {@link com.duitlah.api.notifications.PushNotificationProvider} is honestly
 * unimplemented — see its own Javadoc for why.
 *
 * <p>Module boundary: code outside this package should depend only on this module's public
 * service/DTO surface, not its internal classes.
 */
package com.duitlah.api.notifications;
