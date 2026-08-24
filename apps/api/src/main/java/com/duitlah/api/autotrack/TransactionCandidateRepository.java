package com.duitlah.api.autotrack;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TransactionCandidateRepository extends JpaRepository<TransactionCandidate, UUID> {

  Optional<TransactionCandidate> findByIdAndUserId(UUID id, UUID userId);

  List<TransactionCandidate> findByUserIdAndStatusOrderByDetectedDateDesc(
      UUID userId, CandidateStatus status);

  List<TransactionCandidate> findByUserIdOrderByDetectedDateDesc(UUID userId);
}
