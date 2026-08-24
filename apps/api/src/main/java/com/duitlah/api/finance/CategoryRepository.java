package com.duitlah.api.finance;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, UUID> {

  /** System defaults (userId IS NULL) plus this user's own custom categories. */
  List<Category> findByUserIdIsNullOrUserId(UUID userId);

  Optional<Category> findByIdAndUserId(UUID id, UUID userId);

  List<Category> findByParentId(UUID parentId);
}
