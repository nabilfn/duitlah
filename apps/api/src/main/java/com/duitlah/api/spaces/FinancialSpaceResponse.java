package com.duitlah.api.spaces;

import java.util.UUID;

public record FinancialSpaceResponse(
    UUID id, SpaceType type, String name, SpaceRole yourRole, SpaceStatus status) {

  static FinancialSpaceResponse of(FinancialSpace space, SpaceRole yourRole) {
    return new FinancialSpaceResponse(
        space.getId(), space.getType(), space.getName(), yourRole, space.getStatus());
  }
}
