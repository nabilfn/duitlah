package com.duitlah.api.subscriptions;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserSubscriptionRepository extends JpaRepository<UserSubscription, UUID> {

  Optional<UserSubscription> findByUserId(UUID userId);
}
