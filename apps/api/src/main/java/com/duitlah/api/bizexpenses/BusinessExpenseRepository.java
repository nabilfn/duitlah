package com.duitlah.api.bizexpenses;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BusinessExpenseRepository extends JpaRepository<BusinessExpense, UUID> {

  Optional<BusinessExpense> findByIdAndSpaceId(UUID id, UUID spaceId);

  List<BusinessExpense> findBySpaceIdOrderByOccurredOnDesc(UUID spaceId);

  List<BusinessExpense> findBySpaceIdAndStatusNot(UUID spaceId, ExpenseStatus status);
}
