import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/sidebar_repository_impl.dart';
import '../../domain/entities/nav_group.dart';
import '../../domain/repositories/sidebar_repository.dart';

class SidebarState {
  final bool isCollapsed;
  final String? activeItemId;
  final Set<String> expandedGroups;

  const SidebarState({
    this.isCollapsed = false,
    this.activeItemId,
    this.expandedGroups = const {},
  });

  SidebarState copyWith({
    bool? isCollapsed,
    String? activeItemId,
    Set<String>? expandedGroups,
  }) =>
      SidebarState(
        isCollapsed: isCollapsed ?? this.isCollapsed,
        activeItemId: activeItemId ?? this.activeItemId,
        expandedGroups: expandedGroups ?? this.expandedGroups,
      );
}

class SidebarController extends Notifier<SidebarState> {
  @override
  SidebarState build() => const SidebarState();

  void toggleCollapse() =>
      state = state.copyWith(isCollapsed: !state.isCollapsed);

  void toggleGroup(String groupId) {
    final next = Set<String>.from(state.expandedGroups);
    next.contains(groupId) ? next.remove(groupId) : next.add(groupId);
    state = state.copyWith(expandedGroups: next);
  }

  void selectItem(String itemId) =>
      state = state.copyWith(activeItemId: itemId);
}

final sidebarControllerProvider =
    NotifierProvider<SidebarController, SidebarState>(SidebarController.new);

final _sidebarRepositoryProvider = Provider<SidebarRepository>(
  (_) => const SidebarRepositoryImpl(),
);

final sidebarGroupsProvider = Provider<List<NavGroup>>(
  (ref) => ref.watch(_sidebarRepositoryProvider).getGroups(),
);
