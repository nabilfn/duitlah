package com.duitlah.api.ai;

import com.duitlah.api.bagilah.BillService;
import com.duitlah.api.groups.GroupBalanceResponse;
import com.duitlah.api.groups.GroupResponse;
import com.duitlah.api.groups.GroupService;
import com.duitlah.api.settlements.SettlementService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.stereotype.Component;

/**
 * V2 Phase 12 — spec section 66's Shared tool list ({@code get_group_balances}, {@code
 * get_settlements}, {@code get_bagilah_summary}). "Shared" here means Groups/Bagilah/Settlements —
 * the pre-existing "money split between people" concept — not a {@code spaces.SpaceType}; see
 * {@link AiToolContext}. Always active, regardless of which space (if any) is currently active in
 * the chat, since who-owes-whom questions aren't tied to a Personal/Business context.
 */
@Component
public class SharedAiToolProvider implements AiToolProvider {

  private final GroupService groupService;
  private final SettlementService settlementService;
  private final BillService bagilahBillService;

  public SharedAiToolProvider(
      GroupService groupService,
      SettlementService settlementService,
      BillService bagilahBillService) {
    this.groupService = groupService;
    this.settlementService = settlementService;
    this.bagilahBillService = bagilahBillService;
  }

  @Override
  public AiToolContext context() {
    return AiToolContext.SHARED;
  }

  @Override
  public List<AiToolDefinition> definitions() {
    return List.of(
        AiSchemas.definition(
            "get_group_balances",
            "Who-owes-whom balances for one of the user's groups. Omit groupId to get balances for every group "
                + "the user belongs to.",
            groupBalancesSchema()),
        AiSchemas.definition(
            "get_settlements",
            "Who owes the user money and who the user owes money to, across every group and bill they're part of.",
            AiSchemas.emptyObject()),
        AiSchemas.definition(
            "get_bagilah_summary",
            "The user's Bagilah (receipt-splitting bill) activity: each bill's merchant, date, total, and status.",
            AiSchemas.emptyObject()));
  }

  @Override
  public Object execute(UUID userId, UUID spaceId, String toolName, JsonNode input) {
    return switch (toolName) {
      case "get_group_balances" -> groupBalances(userId, input);
      case "get_settlements" -> settlementService.getSummary(userId);
      case "get_bagilah_summary" -> bagilahBillService.listForUser(userId);
      default -> throw new IllegalArgumentException("Unknown shared tool: " + toolName);
    };
  }

  private Object groupBalances(UUID userId, JsonNode input) {
    if (input != null && input.has("groupId")) {
      UUID groupId = UUID.fromString(input.get("groupId").asText());
      return groupService.getBalances(userId, groupId);
    }
    List<Map<String, Object>> allGroups =
        groupService.listForUser(userId).stream()
            .map(
                (GroupResponse group) -> {
                  List<GroupBalanceResponse> balances =
                      groupService.getBalances(userId, group.id());
                  return Map.<String, Object>of(
                      "groupId", group.id(), "groupName", group.name(), "balances", balances);
                })
            .toList();
    return allGroups;
  }

  private ObjectNode groupBalancesSchema() {
    ObjectNode schema = AiSchemas.object();
    schema
        .putObject("properties")
        .set(
            "groupId",
            AiSchemas.stringProperty(
                "The group's id. Omit to get balances for every group the user belongs to."));
    return schema;
  }
}
