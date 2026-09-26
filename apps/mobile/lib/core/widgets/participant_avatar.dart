import 'package:duitlah_mobile/core/theme/duitlah_colors.dart';
import 'package:duitlah_mobile/core/widgets/duitlah_icon.dart';
import 'package:flutter/material.dart';

/// A colored initial-letter avatar for a Bagilah participant/group member.
/// The color is derived deterministically from the name so the same person
/// gets the same color across screens without fetching/storing a real
/// avatar image.
class ParticipantAvatar extends StatelessWidget {
  const ParticipantAvatar({
    super.key,
    required this.name,
    this.size = 36,
    this.isGuest = false,
  });

  final String name;
  final double size;
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final words = trimmed
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    final initial = words.isEmpty
        ? '?'
        : (words.first[0] + (words.length > 1 ? words.last[0] : ''))
              .toUpperCase();
    final color =
        DuitlahColors.participants[trimmed.codeUnits.fold<int>(
              0,
              (a, b) => a + b,
            ) %
            DuitlahColors.participants.length];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            // The navy palette entry is close in tone to the dark-mode
            // background -- without a visible edge it can lose its circular
            // silhouette entirely rather than just looking monochrome.
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: TextStyle(
              color: context.duitlahColors.onParticipant(color),
              fontWeight: FontWeight.w700,
              fontSize: size * 0.32,
            ),
          ),
        ),
        if (isGuest)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: DuitlahIcon(
                Icons.person_outline,
                size: size * 0.32,
                color: color,
              ),
            ),
          ),
      ],
    );
  }
}
