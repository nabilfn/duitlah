/**
 * Recurring transaction schedules (rent, salary, subscriptions) and the daily job that materializes
 * them into ordinary {@code Transaction} rows.
 *
 * <p>Module boundary: code outside this package should depend only on this module's public
 * service/DTO surface, not its internal classes.
 */
package com.duitlah.api.recurring;
