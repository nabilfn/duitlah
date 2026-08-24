package com.duitlah.api.groups;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GroupGoalRepository extends JpaRepository<GroupGoal, UUID> {

  List<GroupGoal> findByGroupIdOrderByCreatedAtAsc(UUID groupId);

  Optional<GroupGoal> findByIdAndGroupId(UUID id, UUID groupId);
}
