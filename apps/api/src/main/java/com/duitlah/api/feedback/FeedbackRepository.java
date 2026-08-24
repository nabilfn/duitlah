package com.duitlah.api.feedback;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FeedbackRepository extends JpaRepository<Feedback, UUID> {

  List<Feedback> findByUserIdOrderByCreatedAtDesc(UUID userId);
}
