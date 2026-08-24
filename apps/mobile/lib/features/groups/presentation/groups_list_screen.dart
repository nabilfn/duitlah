import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_state_views.dart';
import '../application/groups_providers.dart';

class GroupsListScreen extends ConsumerWidget {
  const GroupsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(icon: const Icon(Icons.group_add_outlined), onPressed: () => context.push(AppRoutes.groupJoin)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(groupListProvider),
        child: groups.when(
          data: (list) => list.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    EmptyView(icon: Icons.groups_outlined, title: 'No groups yet', message: 'Create one to share expenses.'),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final group = list[index];
                    return Card(
                      child: ListTile(
                        title: Text(group.name),
                        subtitle: Text('${group.memberCount} members · ${group.type.name}'),
                        onTap: () => context.push(AppRoutes.groupDetail(group.id)),
                      ),
                    );
                  },
                ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView(error: e, onRetry: () => ref.invalidate(groupListProvider)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.groupCreate),
        icon: const Icon(Icons.add),
        label: const Text('New group'),
      ),
    );
  }
}
