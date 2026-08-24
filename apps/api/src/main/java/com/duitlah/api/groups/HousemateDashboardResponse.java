package com.duitlah.api.groups;

import java.util.List;

public record HousemateDashboardResponse(int year, int month, List<CategoryStatus> categories) {

  public record CategoryStatus(GroupExpenseCategory category, boolean paid) {}
}
