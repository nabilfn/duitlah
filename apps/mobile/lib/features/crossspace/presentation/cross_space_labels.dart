import 'package:flutter/material.dart';

import '../domain/cross_space.dart';

/// Plain-language labels for [CrossSpaceLinkType] — shown in the hub's
/// action tiles and history list instead of the raw enum name, mirroring
/// `assets/presentation/asset_labels.dart`'s `depreciationMethodLabel`.
String crossSpaceLinkTypeLabel(CrossSpaceLinkType type) {
  switch (type) {
    case CrossSpaceLinkType.BUSINESS_ADVANCE:
      return 'Business Advance';
    case CrossSpaceLinkType.REIMBURSEMENT:
      return 'Reimbursement';
    case CrossSpaceLinkType.OWNER_CONTRIBUTION:
      return 'Owner Contribution';
    case CrossSpaceLinkType.OWNER_DRAWING:
      return 'Owner Drawing';
  }
}

/// One line of plain-language help shown under each action tile — what it
/// means in the real world, not backend jargon.
String crossSpaceLinkTypeDescription(CrossSpaceLinkType type) {
  switch (type) {
    case CrossSpaceLinkType.BUSINESS_ADVANCE:
      return 'You paid personally for something the business needed. Records what the business now owes you.';
    case CrossSpaceLinkType.REIMBURSEMENT:
      return 'The business paid you back for money you spent on its behalf.';
    case CrossSpaceLinkType.OWNER_CONTRIBUTION:
      return 'You put your own money into the business.';
    case CrossSpaceLinkType.OWNER_DRAWING:
      return 'You took money out of the business for personal use.';
  }
}

IconData crossSpaceLinkTypeIcon(CrossSpaceLinkType type) {
  switch (type) {
    case CrossSpaceLinkType.BUSINESS_ADVANCE:
      return Icons.upload_outlined;
    case CrossSpaceLinkType.REIMBURSEMENT:
      return Icons.replay_outlined;
    case CrossSpaceLinkType.OWNER_CONTRIBUTION:
      return Icons.savings_outlined;
    case CrossSpaceLinkType.OWNER_DRAWING:
      return Icons.download_outlined;
  }
}
