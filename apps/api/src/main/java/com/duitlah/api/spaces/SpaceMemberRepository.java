package com.duitlah.api.spaces;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SpaceMemberRepository extends JpaRepository<SpaceMember, UUID> {

  List<SpaceMember> findByUserIdAndStatus(UUID userId, MemberStatus status);

  Optional<SpaceMember> findBySpaceIdAndUserId(UUID spaceId, UUID userId);

  List<SpaceMember> findBySpaceIdAndStatus(UUID spaceId, MemberStatus status);
}
