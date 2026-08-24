package com.duitlah.api.bagilah;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface BillRepository extends JpaRepository<Bill, UUID> {

  Optional<Bill> findByInviteTokenHash(String inviteTokenHash);

  @Query(
      """
      SELECT DISTINCT b FROM Bill b
      WHERE b.ownerUserId = :userId
         OR b.id IN (SELECT p.billId FROM BillParticipant p WHERE p.userId = :userId)
      ORDER BY b.createdAt DESC
      """)
  List<Bill> findAllVisibleToUser(@Param("userId") UUID userId);
}
