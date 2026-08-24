package com.duitlah.api.exports;

import java.util.List;

/**
 * A generic table (headers + rows, everything already stringified) — domain-agnostic input for
 * every format writer, so a new export just needs to produce one of these, not its own CSV/XLSX/
 * PDF-writing code.
 */
public record TabularData(String title, List<String> headers, List<List<String>> rows) {}
