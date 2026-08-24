package com.duitlah.api.statements;

import java.util.List;

/** Adapter interface (spec section 13) — one implementation per supported file shape/provider. */
public interface StatementParser {

  StatementProvider provider();

  /**
   * Never throws for "this line didn't look like a transaction" — an unparseable row is just
   * skipped, not a reason to fail the whole file (spec: "provide a review experience instead of
   * failing completely"). Only genuinely unreadable input (not a CSV/XLSX/PDF at all) should throw.
   */
  List<ParsedStatementRow> parse(byte[] fileBytes);
}
