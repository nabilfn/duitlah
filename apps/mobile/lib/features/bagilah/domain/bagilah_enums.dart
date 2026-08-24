// ignore_for_file: constant_identifier_names
// Enum constant names intentionally match the backend's exact string
// values (see docs/bagilah-engine.md) so json_serializable's default
// name-based enum (de)serialization needs no custom converter.

enum BillStatus { DRAFT, FINALIZED, CANCELLED }

enum AllocationStrategy { PROPORTIONAL, EQUAL }

enum ClaimType { QUANTITY, PERCENTAGE, AMOUNT }

enum IssueType { UNCLAIMED, OVERALLOCATED, MIXED_CLAIM_TYPES }
