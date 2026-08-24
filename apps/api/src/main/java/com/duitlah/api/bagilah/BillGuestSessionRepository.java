package com.duitlah.api.bagilah;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BillGuestSessionRepository extends JpaRepository<BillGuestSession, UUID> {

  Optional<BillGuestSession> findByTokenHash(String tokenHash);
}
