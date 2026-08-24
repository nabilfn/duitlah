package com.duitlah.api.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

/** Enables {@code @Scheduled} jobs — first used by {@code RecurringTransactionScheduler}. */
@Configuration
@EnableScheduling
public class SchedulingConfig {}
