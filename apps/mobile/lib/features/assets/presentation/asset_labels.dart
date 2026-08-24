import '../domain/fixed_assets.dart';

/// Plain-language labels for the raw enum names — shown in pickers and
/// detail views instead of `DepreciationMethod.name`, mirroring how
/// `journal_entries_screen.dart`'s `sourceLabel` translates
/// `JournalSourceType` for display.
String depreciationMethodLabel(DepreciationMethod method) {
  switch (method) {
    case DepreciationMethod.STRAIGHT_LINE:
      return 'Straight-Line';
    case DepreciationMethod.DOUBLE_DECLINING_BALANCE:
      return 'Double Declining Balance';
  }
}
