import 'package:flutter/material.dart';

/// A colored initial-letter avatar for a Bagilah participant/group member.
/// The color is derived deterministically from the name so the same person
/// gets the same color across screens without fetching/storing a real
/// avatar image.
class ParticipantAvatar extends StatelessWidget {
  const ParticipantAvatar({super.key, required this.name, this.size = 36, this.isGuest = false});

  final String name;
  final double size;
  final bool isGuest;

  // A deliberately-designed "connected people" set (redesign spec section
  // 7) that lives comfortably alongside the teal/navy/orange brand palette,
  // not six arbitrary hues -- teal and navy are the brand's own colors, and
  // the other four are chosen to read as a cohesive family with them rather
  // than clashing. The orange here is a deeper shade than the UI accent
  // (`AppColors.orange`) specifically so white initials stay legible; the
  // brighter accent value is for small highlights, not a solid fill behind
  // white text.
  static const _palette = [
    Color(0xFF00A8AD), // teal
    Color(0xFF0D1B2A), // navy
    Color(0xFFD97706), // deep orange
    Color(0xFF5B6EE8), // indigo
    Color(0xFF9B6FD1), // plum
    Color(0xFFD97757), // terracotta
  ];

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
    final color = _palette[trimmed.codeUnits.fold<int>(0, (a, b) => a + b) % _palette.length];

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
            border: Border.all(color: Theme.of(context).colorScheme.surface, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            initial,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: size * 0.42,
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
              child: Icon(Icons.person_outline, size: size * 0.32, color: color),
            ),
          ),
      ],
    );
  }
}
