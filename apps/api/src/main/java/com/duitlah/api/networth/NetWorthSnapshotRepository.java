package com.duitlah.api.networth;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NetWorthSnapshotRepository extends JpaRepository<NetWorthSnapshot, UUID> {

  List<NetWorthSnapshot> findByUserIdOrderBySnapshotDateAsc(UUID userId);
}
