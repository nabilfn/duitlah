# Whole-app consistency audit

Source inventory captured before changes. Scope includes every existing Flutter presentation file and shared UI component; service, repository, model and routing behavior are outside this pass.

## Findings and implementation priorities

- Forms mix floating dropdown labels, floating text labels and custom authentication fields. Account inherits dropdown positioning that differs from the other fields. Adopt a shared external field group for application forms, retaining the dedicated login treatment.
- Secondary pages use 16, 20 and 24-point page edges; card insets and page edges share the same token. Introduce explicit page and form rhythm tokens without changing card insets.
- Sheets each add keyboard padding but do not share a bottom system-safe-area contract. Preserve their scrolling and keyboard insets, add shared bottom protection.
- Transaction, tool and receipt searches are separate implementations; only some have clear controls. Consolidate the interaction while preserving local vs server-submitted search behavior.
- Money rows share AmountText, but ancillary reports and bills interpolate raw RM strings. Normalize display formatting without touching calculations.
- Budget remaining values are metadata while spent values dominate. Promote the authoritative remaining value and keep warnings text-based.
- Business summary nests a navy surface inside a matte card and tightly packs counts. Simplify the nesting and use wrapping contextual metrics.
- Notification rows omit available timestamps and rely on icon/weight for unread status. Add explicit unread labels, date grouping and failure recovery.
- Empty/error states have fixed action widths and no constrained-scroll handling. Standardize adaptive states and concise error recovery.
- Buttons, date pickers and native popup controls need matching typography, targets and theme surfaces. Reuse the global theme rather than new page styles.
- Existing glass, navigation, assistant expansion, login entry motion and primary page compositions are retained. Audit reduced-motion and safe-area behavior through regression tests.

## Complete source inventory

Fields/selectors and empty/loading/error counts identify shared-component coverage, not a claim that every runtime state was visually exercised.

| File | Public presentation widgets | Fields/selectors | Empty/loading/error |
| --- | --- | --- | --- |
| `features/accounting/presentation/accounting_hub_screen.dart` | AccountingHubScreen, _Tile | 0/0 | 0/0/0 |
| `features/accounting/presentation/accounting_periods_screen.dart` | AccountingPeriodsScreen | 0/0 | 1/1/1 |
| `features/accounting/presentation/balance_sheet_screen.dart` | BalanceSheetScreen, _Body | 0/0 | 0/1/1 |
| `features/accounting/presentation/cash_flow_screen.dart` | CashFlowScreen | 0/0 | 0/1/1 |
| `features/accounting/presentation/chart_of_accounts_screen.dart` | ChartOfAccountsScreen | 4/1 | 1/1/1 |
| `features/accounting/presentation/general_ledger_screen.dart` | GeneralLedgerScreen, _ReportBody | 0/1 | 1/2/2 |
| `features/accounting/presentation/income_statement_screen.dart` | IncomeStatementScreen, _Body | 0/0 | 0/1/1 |
| `features/accounting/presentation/journal_entries_screen.dart` | JournalEntriesScreen, _JournalEntryFormSheet | 2/0 | 1/1/1 |
| `features/accounting/presentation/reports_hub_screen.dart` | ReportsHubScreen, _Tile | 0/0 | 0/0/0 |
| `features/accounting/presentation/trial_balance_screen.dart` | TrialBalanceScreen, _Table | 0/0 | 0/1/1 |
| `features/accounting/presentation/widgets/journal_line_editor.dart` | JournalLineEditor | 4/1 | 0/0/0 |
| `features/accounts/presentation/accounts_screen.dart` | AccountsScreen | 2/1 | 1/1/1 |
| `features/accounts/presentation/categories_screen.dart` | CategoriesScreen | 0/0 | 1/1/1 |
| `features/assets/presentation/asset_detail_screen.dart` | AssetDetailScreen, _AssetHeaderCard, _Stat, _DepreciationTile, _DisposeSheet | 2/1 | 1/2/2 |
| `features/assets/presentation/asset_labels.dart` | Supporting presentation | 0/0 | 0/0/0 |
| `features/assets/presentation/assets_hub_screen.dart` | AssetsHubScreen, _AssetTile | 0/0 | 1/1/1 |
| `features/assets/presentation/widgets/asset_form_sheet.dart` | AssetFormSheet | 10/2 | 0/0/0 |
| `features/assistant/presentation/assistant_screen.dart` | AssistantScreen, _SpaceContextBar, _ChatBubble, _ObligationRow | 6/0 | 1/0/0 |
| `features/auth/presentation/login_screen.dart` | LoginScreen, _ErrorLine, EntryField, EntrySignInButton | 3/0 | 0/0/0 |
| `features/auth/presentation/register_screen.dart` | RegisterScreen | 6/0 | 0/0/0 |
| `features/auth/presentation/splash_screen.dart` | SplashScreen | 0/0 | 0/0/0 |
| `features/autotrack/presentation/autotrack_candidates_screen.dart` | AutoTrackCandidatesScreen | 4/1 | 1/1/1 |
| `features/autotrack/presentation/statement_import_screen.dart` | StatementImportScreen, _AccountPicker | 0/1 | 0/1/1 |
| `features/bagilah/presentation/bagilah_join_screen.dart` | BagilahJoinScreen | 2/0 | 0/1/0 |
| `features/bagilah/presentation/bill_detail_screen.dart` | BillDetailScreen | 8/0 | 1/4/4 |
| `features/bagilah/presentation/bills_list_screen.dart` | BillsListScreen, _AllSplitsScreen | 0/0 | 1/2/2 |
| `features/bagilah/presentation/claim_item_sheet.dart` | ClaimItemSheet | 2/1 | 0/0/0 |
| `features/bagilah/presentation/create_bill_screen.dart` | CreateBillScreen | 2/0 | 0/0/0 |
| `features/bagilah/presentation/guest_bill_screen.dart` | GuestBillScreen | 0/0 | 1/3/2 |
| `features/bagilah/presentation/qr_invite_sheet.dart` | QrInviteSheet | 0/0 | 0/0/0 |
| `features/bagilah/presentation/qr_scan_screen.dart` | QrScanScreen | 0/0 | 0/0/0 |
| `features/bagilah/presentation/receipt_capture_screen.dart` | ReceiptCaptureScreen | 0/0 | 0/0/0 |
| `features/bagilah/presentation/receipt_review_screen.dart` | ReceiptReviewScreen | 14/0 | 0/1/1 |
| `features/bagilah/presentation/shared_money_composition.dart` | SharedMoneyComposition, _ParticipantNode, _RelationshipDetails | 0/0 | 0/2/1 |
| `features/bills/presentation/bills_screen.dart` | BillsScreen | 8/2 | 1/1/1 |
| `features/budgets/presentation/budgets_screen.dart` | BudgetsScreen | 2/0 | 1/1/1 |
| `features/business/presentation/business_account_detail_screen.dart` | BusinessAccountDetailScreen | 12/1 | 0/2/2 |
| `features/business/presentation/business_accounts_screen.dart` | BusinessAccountsScreen | 6/1 | 1/1/1 |
| `features/business/presentation/business_dashboard_screen.dart` | BusinessDashboardScreen, _HeadlineCard, _Stat, _NavTile | 0/0 | 0/1/1 |
| `features/business/presentation/contacts_screen.dart` | _ContactsBody, CustomersScreen, SuppliersScreen | 20/0 | 1/2/2 |
| `features/business/presentation/credit_notes_screen.dart` | CreditNotesScreen | 6/1 | 1/1/1 |
| `features/business/presentation/expense_detail_screen.dart` | ExpenseDetailScreen | 6/1 | 0/2/2 |
| `features/business/presentation/expenses_screen.dart` | ExpensesScreen | 8/1 | 1/1/1 |
| `features/business/presentation/invoice_detail_screen.dart` | InvoiceDetailScreen | 6/1 | 0/2/2 |
| `features/business/presentation/invoices_screen.dart` | InvoicesScreen, _InvoiceFormSheet | 8/1 | 1/2/1 |
| `features/business/presentation/products_screen.dart` | ProductsScreen | 14/2 | 1/1/1 |
| `features/business/presentation/quotation_detail_screen.dart` | QuotationDetailScreen | 2/0 | 0/1/1 |
| `features/business/presentation/quotations_screen.dart` | QuotationsScreen, _QuotationFormSheet | 8/1 | 1/2/1 |
| `features/business/presentation/recurring_invoices_screen.dart` | RecurringInvoicesScreen, _RecurringInvoiceFormSheet | 8/2 | 1/2/1 |
| `features/business/presentation/widgets/einvoice_section.dart` | EInvoiceSection, _NotStarted, _StatusChip, _DocumentBody, _Field, _LogsExpansion, _LogTile | 1/0 | 0/2/2 |
| `features/business/presentation/widgets/line_items_editor.dart` | LineItemsEditor | 6/1 | 0/0/0 |
| `features/business_tax/presentation/business_tax_hub_screen.dart` | BusinessTaxHubScreen, _ReadinessCard, _SstRateTile | 0/0 | 1/3/3 |
| `features/crossspace/presentation/combined_net_worth_screen.dart` | CombinedNetWorthScreen, _Summary, _OwnershipTile | 0/0 | 1/1/1 |
| `features/crossspace/presentation/cross_space_hub_screen.dart` | CrossSpaceHubScreen, _ActionTile, _LinkTile | 0/0 | 1/1/1 |
| `features/crossspace/presentation/cross_space_labels.dart` | Supporting presentation | 0/0 | 0/0/0 |
| `features/crossspace/presentation/widgets/link_form_sheet.dart` | LinkFormSheet | 4/3 | 0/0/0 |
| `features/crossspace/presentation/widgets/personal_transaction_picker_sheet.dart` | PersonalTransactionPickerSheet | 0/0 | 1/1/1 |
| `features/exports/presentation/exports_screen.dart` | ExportsScreen, _ExportTile | 0/0 | 0/0/0 |
| `features/feedback/presentation/feedback_screen.dart` | FeedbackScreen | 1/1 | 0/0/0 |
| `features/feedback/presentation/help_support_screen.dart` | HelpSupportScreen | 0/0 | 0/0/0 |
| `features/finhealth/presentation/financial_health_screen.dart` | FinancialHealthScreen | 0/0 | 0/1/1 |
| `features/goals/presentation/goal_editor_sheet.dart` | GoalEditorSheet | 4/0 | 0/0/0 |
| `features/goals/presentation/goals_screen.dart` | GoalsScreen | 2/0 | 1/1/1 |
| `features/groups/presentation/create_group_screen.dart` | CreateGroupScreen | 2/1 | 0/0/0 |
| `features/groups/presentation/group_detail_screen.dart` | GroupDetailScreen | 10/2 | 2/2/2 |
| `features/groups/presentation/group_goals_section.dart` | GroupGoalsSection, _GoalCard | 6/0 | 1/1/1 |
| `features/groups/presentation/groups_list_screen.dart` | GroupsListScreen | 0/0 | 1/1/1 |
| `features/groups/presentation/housemate_mode_section.dart` | HousemateModeSection | 0/0 | 0/1/1 |
| `features/groups/presentation/join_group_screen.dart` | JoinGroupScreen | 2/0 | 0/0/0 |
| `features/groups/presentation/trip_mode_section.dart` | TripModeSection, _Stat | 2/0 | 1/1/1 |
| `features/home/presentation/budget_trajectory.dart` | BudgetTrajectory | 0/0 | 0/0/0 |
| `features/home/presentation/home_screen.dart` | HomeScreen, _FinancialCanvas, _HomeCommands, _HomeAmount | 0/0 | 1/4/3 |
| `features/home/presentation/more_menu_screen.dart` | MoreMenuScreen | 1/0 | 0/0/0 |
| `features/insights/presentation/calendar_screen.dart` | CalendarScreen, _CalendarEntryTile | 0/0 | 1/1/1 |
| `features/insights/presentation/insights_screen.dart` | InsightsScreen, SpendingDonut, _ForecastCard, _MiniAmount, _MonthlyTrendChart | 0/0 | 4/6/6 |
| `features/inventory/presentation/inventory_hub_screen.dart` | InventoryHubScreen | 0/0 | 1/2/2 |
| `features/inventory/presentation/product_inventory_screen.dart` | ProductInventoryScreen, _ValuationCard, _Stat, _MovementTile, _RecipeCostCard, _MovementFormSheet, _AddIngredientSheet | 8/3 | 2/4/4 |
| `features/liabilities/presentation/credit_card_details_screen.dart` | CreditCardDetailsScreen, _Field | 6/0 | 0/1/1 |
| `features/liabilities/presentation/liabilities_screen.dart` | LiabilitiesScreen | 10/1 | 1/1/1 |
| `features/networth/presentation/net_worth_screen.dart` | NetWorthScreen, _Summary, _BreakdownTile | 4/1 | 0/1/1 |
| `features/notificationrules/presentation/notification_rules_screen.dart` | NotificationRulesScreen, _ThresholdField | 2/0 | 0/1/1 |
| `features/notifications/presentation/notifications_screen.dart` | NotificationsScreen | 0/0 | 1/1/1 |
| `features/personaltax/presentation/pcb_screen.dart` | PcbScreen | 2/1 | 1/1/1 |
| `features/personaltax/presentation/personal_income_screen.dart` | PersonalIncomeScreen | 4/1 | 1/1/1 |
| `features/personaltax/presentation/personal_tax_screen.dart` | PersonalTaxScreen, _CalculationCard, _Row, _ReadinessCard, _NavTile | 0/0 | 1/1/1 |
| `features/personaltax/presentation/tax_documents_screen.dart` | TaxDocumentsScreen | 0/0 | 1/1/1 |
| `features/personaltax/presentation/tax_reliefs_screen.dart` | TaxReliefsScreen | 4/1 | 0/2/2 |
| `features/personaltax/presentation/zakat_screen.dart` | ZakatScreen | 2/0 | 1/1/1 |
| `features/profile/presentation/profile_screen.dart` | ProfileScreen | 1/0 | 0/0/0 |
| `features/receipts/presentation/receipt_vault_screen.dart` | ReceiptVaultScreen, _ReceiptCard | 2/0 | 1/1/1 |
| `features/receipts/presentation/vault_receipt_detail_screen.dart` | VaultReceiptDetailScreen, _MatchSuggestionsList, _Field | 0/0 | 0/2/2 |
| `features/reconciliation/presentation/reconciliation_hub_screen.dart` | ReconciliationHubScreen, _StatusChip, _AccountPicker | 0/1 | 1/1/1 |
| `features/reconciliation/presentation/reconciliation_session_screen.dart` | ReconciliationSessionScreen, _Body, _SummaryCard, _Count, _LineTile, _MatchSheet, _SuggestionTile, _SplitSheet | 4/0 | 1/5/5 |
| `features/reconciliation/presentation/widgets/split_portions_editor.dart` | SplitPortionsEditor | 4/0 | 0/0/0 |
| `features/recurring/presentation/recurring_transactions_screen.dart` | RecurringTransactionsScreen, _RuleCard, _RecurringTransactionForm | 4/2 | 1/1/1 |
| `features/settlements/presentation/settlements_screen.dart` | SettlementsScreen | 2/0 | 1/1/1 |
| `features/spaces/presentation/business_profile_screen.dart` | BusinessProfileScreen, _Field | 0/0 | 0/1/1 |
| `features/spaces/presentation/create_business_space_screen.dart` | CreateBusinessSpaceScreen | 10/0 | 0/0/0 |
| `features/spaces/presentation/spaces_screen.dart` | SpacesScreen, _SpaceCard | 0/0 | 0/1/1 |
| `features/spaces/presentation/team_screen.dart` | TeamScreen | 2/2 | 1/1/1 |
| `features/spaces/presentation/widgets/business_profile_form_sheet.dart` | BusinessProfileFormSheet | 24/0 | 0/0/0 |
| `features/splash/presentation/app_entry_transition.dart` | AppEntryTransition, _EntryStage, _Layer, _Welcome, EntryLoginSection | 0/0 | 0/0/0 |
| `features/subscriptions/presentation/duitlah_plus_screen.dart` | DuitlahPlusScreen, _UsageRow | 0/0 | 0/1/1 |
| `features/subscriptions/presentation/upgrade_dialog.dart` | Supporting presentation | 0/0 | 0/0/0 |
| `features/transactionrules/presentation/transaction_rules_screen.dart` | TransactionRulesScreen, _RuleFormSheet | 4/2 | 1/1/1 |
| `features/transactions/presentation/transaction_form_sheet.dart` | TransactionFormSheet | 3/3 | 1/1/1 |
| `features/transactions/presentation/transactions_screen.dart` | TransactionsScreen | 1/0 | 1/1/1 |
| `features/wrapped/presentation/monthly_wrapped_screen.dart` | MonthlyWrappedScreen, _OpeningState, WrappedStoryView | 0/0 | 0/0/0 |
| `features/wrapped/presentation/stories/wrapped_chapters.dart` | WrappedChapterContent | 0/0 | 0/0/0 |
| `features/wrapped/presentation/widgets/persona_visuals.dart` | PersonaMotif | 0/0 | 0/0/0 |
| `features/wrapped/presentation/widgets/story_progress_bar.dart` | StoryProgressBar | 0/0 | 0/0/0 |
| `features/wrapped/presentation/widgets/wrapped_editorial.dart` | WrappedEyebrow, WrappedEntrance, AnimatedMoney, WrappedPill, WrappedTile, WrappedResize | 0/0 | 0/0/0 |
| `features/wrapped/presentation/widgets/wrapped_history_section.dart` | WrappedHistorySection, _WrappedHistoryTile | 0/0 | 0/1/0 |
| `features/wrapped/presentation/widgets/wrapped_promo_card.dart` | WrappedPromoCard | 0/0 | 0/0/0 |
| `features/wrapped/presentation/widgets/wrapped_share_card.dart` | WrappedShareCard | 0/0 | 0/0/0 |
| `features/wrapped/presentation/widgets/wrapped_share_sheet.dart` | WrappedShareSheet | 0/0 | 0/0/0 |
