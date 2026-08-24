package com.duitlah.api.bills;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PersonalBillRepository extends JpaRepository<PersonalBill, UUID> {

  Optional<PersonalBill> findByIdAndUserId(UUID id, UUID userId);

  List<PersonalBill> findByUserIdOrderByDueDateAsc(UUID userId);

  List<PersonalBill> findByUserIdAndStatusOrderByDueDateAsc(UUID userId, BillStatus status);

  List<PersonalBill> findByStatusAndDueDateLessThanEqual(BillStatus status, LocalDate date);

  List<PersonalBill> findByStatusInAndDueDateLessThan(List<BillStatus> statuses, LocalDate date);
}
