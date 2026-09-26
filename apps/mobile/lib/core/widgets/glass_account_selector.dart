import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_routes.dart';
import '../theme/duitlah_colors.dart';
import '../theme/glass_tokens.dart';
import 'editorial_surfaces.dart';
import 'duitlah_icon.dart';

/// Each menu choice opens an existing view; it never changes financial scope
/// locally or combines personal/business ledgers on the Home screen.
enum AccountView { personal, business, both }

class GlassAccountSelector extends StatelessWidget {
  const GlassAccountSelector({super.key, this.view = AccountView.personal});
  final AccountView view;
  @override
  Widget build(BuildContext context) => MenuAnchor(
    style: const MenuStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
      shadowColor: WidgetStatePropertyAll(Colors.transparent),
      elevation: WidgetStatePropertyAll(0),
      padding: WidgetStatePropertyAll(EdgeInsets.zero),
    ),
    menuChildren: [
      DuitlahGlassSurface(
        material: GlassMaterial.strong,
        elevated: true,
        child: Material(
          type: MaterialType.transparency,
          child: SizedBox(
            width: 220,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MenuItemButton(
                  onPressed: () => context.go(AppRoutes.home),
                  leadingIcon: view == AccountView.personal
                      ? const DuitlahIcon(Icons.check, size: 18)
                      : null,
                  child: const Text('Personal'),
                ),
                MenuItemButton(
                  onPressed: () => context.push(AppRoutes.spaces),
                  leadingIcon: view == AccountView.business
                      ? const DuitlahIcon(Icons.check, size: 18)
                      : null,
                  child: const Text('Business'),
                ),
                MenuItemButton(
                  onPressed: () => context.push(AppRoutes.combinedNetWorth),
                  leadingIcon: view == AccountView.both
                      ? const DuitlahIcon(Icons.check, size: 18)
                      : null,
                  child: const Text('Both · combined net worth'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
    builder: (context, controller, child) => DuitlahGlassButton(
      label: 'Account view',
      radius: 14,
      elevated: false,
      blur: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onPressed: () =>
          controller.isOpen ? controller.close() : controller.open(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            switch (view) {
              AccountView.personal => 'Personal',
              AccountView.business => 'Business',
              AccountView.both => 'Both',
            },
            style: TextStyle(
              color: context.duitlahColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          DuitlahIcon(
            Icons.expand_more,
            size: 16,
            color: context.duitlahColors.textSecondary,
          ),
        ],
      ),
    ),
  );
}
