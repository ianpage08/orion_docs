# Sidebar Navigation System — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a futuristic glassmorphism sidebar navigation system for Orion Docs using Flutter + Clean Architecture + Riverpod.

**Architecture:** Domain entities (NavItem, NavGroup) are framework-free; a SidebarRepository abstraction lives in the domain layer with a concrete data implementation; Riverpod providers wire everything together and drive a pure-presentation widget tree.

**Tech Stack:** Flutter 3.x (SDK ^3.9.2), flutter_riverpod ^2.6.1, google_fonts ^6.2.1, flutter_animate ^4.5.0, Material 3, Windows desktop target.

---

## File Map

| Action | Path | Responsibility |
|--------|------|----------------|
| Modify | `pubspec.yaml` | Add riverpod, google_fonts, flutter_animate |
| Create | `lib/core/theme/app_colors.dart` | Design token — all colors (dark + light) |
| Create | `lib/core/theme/app_spacing.dart` | Design token — spacing scale + sidebar widths |
| Create | `lib/core/theme/app_typography.dart` | Design token — Inter-based text styles |
| Create | `lib/core/theme/app_theme.dart` | ThemeData light + dark |
| Create | `lib/features/sidebar/domain/entities/nav_item.dart` | Domain entity |
| Create | `lib/features/sidebar/domain/entities/nav_group.dart` | Domain entity |
| Create | `lib/features/sidebar/domain/repositories/sidebar_repository.dart` | Abstract repository |
| Create | `lib/features/sidebar/data/repositories/sidebar_repository_impl.dart` | Concrete data — all 6 groups/items |
| Create | `lib/features/sidebar/presentation/controllers/sidebar_controller.dart` | SidebarState + Notifier + Providers |
| Create | `lib/features/sidebar/presentation/widgets/sidebar_item.dart` | Leaf item: hover, active, keyboard |
| Create | `lib/features/sidebar/presentation/widgets/sidebar_group.dart` | Expandable group header + items |
| Create | `lib/features/sidebar/presentation/widgets/sidebar_header.dart` | Logo + title + collapse toggle |
| Create | `lib/features/sidebar/presentation/widgets/sidebar.dart` | Root sidebar: glass, animated width |
| Modify | `lib/main.dart` | ProviderScope, AppShell, AnimatedBackground |

---

## Task 1: Add dependencies

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Update pubspec.yaml**

Replace the `dependencies` block:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^2.6.1
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.0
```

- [ ] **Step 2: Fetch dependencies**

```bash
flutter pub get
```

Expected: `Got dependencies!` with no errors.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "feat: add riverpod, google_fonts, flutter_animate dependencies"
```

---

## Task 2: Design tokens

**Files:**
- Create: `lib/core/theme/app_colors.dart`
- Create: `lib/core/theme/app_spacing.dart`
- Create: `lib/core/theme/app_typography.dart`
- Create: `lib/core/theme/app_theme.dart`

- [ ] **Step 1: Create `lib/core/theme/app_colors.dart`**

```dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color darkBg = Color(0xFF0B0F1A);
  static const Color lightBg = Color(0xFFF8FAFC);

  static const Color gradientStart = Color(0xFF8B5CF6);
  static const Color gradientMid   = Color(0xFF3B82F6);
  static const Color gradientEnd   = Color(0xFF6366F1);

  static const Color sidebarSurface = Color(0x12FFFFFF);
  static const Color sidebarBorder  = Color(0x18FFFFFF);

  static const Color activeItemBg = Color(0x228B5CF6);
  static const Color hoverItemBg  = Color(0x10FFFFFF);
  static const Color neonGlow     = Color(0x508B5CF6);

  static const Color textPrimary   = Color(0xFFE2E8F0);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted     = Color(0xFF64748B);
  static const Color textActive    = Color(0xFFAB85FF);

  // Light variants
  static const Color lightSidebarSurface  = Color(0xD9FFFFFF);
  static const Color lightSidebarBorder   = Color(0x1A6366F1);
  static const Color lightTextPrimary     = Color(0xFF1E293B);
  static const Color lightTextSecondary   = Color(0xFF475569);
  static const Color lightTextMuted       = Color(0xFF94A3B8);
  static const Color lightTextActive      = Color(0xFF6366F1);
  static const Color lightActiveItemBg    = Color(0x1A6366F1);
  static const Color lightHoverItemBg     = Color(0x0A6366F1);
}
```

- [ ] **Step 2: Create `lib/core/theme/app_spacing.dart`**

```dart
class AppSpacing {
  AppSpacing._();

  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 24;
  static const double xxl  = 32;
  static const double xxxl = 48;

  static const double sidebarExpanded  = 260;
  static const double sidebarCollapsed = 64;
  static const double borderRadius     = 16;
  static const double itemRadius       = 10;
}
```

- [ ] **Step 3: Create `lib/core/theme/app_typography.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get display => GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get headline => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
      );

  static TextStyle get title => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.1,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
        letterSpacing: 0.6,
      );
}
```

- [ ] **Step 4: Create `lib/core/theme/app_theme.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.gradientStart,
          secondary: AppColors.gradientMid,
          tertiary: AppColors.gradientEnd,
          surface: Color(0xFF111827),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.gradientStart,
          secondary: AppColors.gradientMid,
          tertiary: AppColors.gradientEnd,
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      );
}
```

- [ ] **Step 5: Verify compilation**

```bash
flutter analyze lib/core/
```

Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/core/
git commit -m "feat: add core design tokens and theme (AppColors, AppSpacing, AppTypography, AppTheme)"
```

---

## Task 3: Domain layer

**Files:**
- Create: `lib/features/sidebar/domain/entities/nav_item.dart`
- Create: `lib/features/sidebar/domain/entities/nav_group.dart`
- Create: `lib/features/sidebar/domain/repositories/sidebar_repository.dart`

- [ ] **Step 1: Create `lib/features/sidebar/domain/entities/nav_item.dart`**

```dart
class NavItem {
  final String id;
  final String label;

  const NavItem({required this.id, required this.label});
}
```

- [ ] **Step 2: Create `lib/features/sidebar/domain/entities/nav_group.dart`**

```dart
import 'nav_item.dart';

class NavGroup {
  final String id;
  final String label;
  final List<NavItem> items;

  const NavGroup({
    required this.id,
    required this.label,
    required this.items,
  });
}
```

- [ ] **Step 3: Create `lib/features/sidebar/domain/repositories/sidebar_repository.dart`**

```dart
import '../entities/nav_group.dart';

abstract class SidebarRepository {
  List<NavGroup> getGroups();
}
```

- [ ] **Step 4: Commit**

```bash
git add lib/features/
git commit -m "feat: add sidebar domain entities and abstract repository"
```

---

## Task 4: Data layer

**Files:**
- Create: `lib/features/sidebar/data/repositories/sidebar_repository_impl.dart`

- [ ] **Step 1: Create `lib/features/sidebar/data/repositories/sidebar_repository_impl.dart`**

```dart
import '../../domain/entities/nav_group.dart';
import '../../domain/entities/nav_item.dart';
import '../../domain/repositories/sidebar_repository.dart';

class SidebarRepositoryImpl implements SidebarRepository {
  const SidebarRepositoryImpl();

  @override
  List<NavGroup> getGroups() => const [
        NavGroup(id: 'contratos', label: 'Contratos', items: [
          NavItem(id: 'contrato_aluguel', label: 'Contrato de aluguel'),
          NavItem(id: 'contrato_compra_venda', label: 'Contrato de compra e venda'),
          NavItem(id: 'contrato_doacao', label: 'Contrato de doação'),
        ]),
        NavGroup(id: 'recibos', label: 'Recibos', items: [
          NavItem(id: 'recibo_simples', label: 'Recibo simples'),
          NavItem(id: 'recibo_aluguel', label: 'Recibo de aluguel'),
          NavItem(id: 'quitacao_antecipada', label: 'Quitação antecipada'),
          NavItem(id: 'honorarios_profissionais', label: 'Honorários profissionais'),
        ]),
        NavGroup(id: 'decl_eventos', label: 'Declarações Eventos', items: [
          NavItem(id: 'conformidade_sonora', label: 'Conformidade sonora'),
          NavItem(id: 'baixo_impacto', label: 'Baixo impacto'),
          NavItem(id: 'montagem_estruturas', label: 'Montagem de estruturas'),
        ]),
        NavGroup(id: 'decl_adm', label: 'Declarações Administrativas', items: [
          NavItem(id: 'residencia', label: 'Residência'),
          NavItem(id: 'inexistencia_vinculo', label: 'Inexistência de vínculo'),
          NavItem(id: 'veracidade_informacoes', label: 'Veracidade de informações'),
        ]),
        NavGroup(id: 'requerimentos', label: 'Requerimentos', items: [
          NavItem(id: 'ligacao_nova', label: 'Ligação nova'),
          NavItem(id: 'mudanca_cavalete', label: 'Mudança de cavalete'),
        ]),
        NavGroup(id: 'procuracoes', label: 'Procurações', items: [
          NavItem(id: 'alteracao_titularidade', label: 'Alteração de titularidade'),
        ]),
      ];
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/sidebar/data/
git commit -m "feat: add sidebar data layer with all 6 groups and items"
```

---

## Task 5: Riverpod controller

**Files:**
- Create: `lib/features/sidebar/presentation/controllers/sidebar_controller.dart`

- [ ] **Step 1: Create `lib/features/sidebar/presentation/controllers/sidebar_controller.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/sidebar_repository_impl.dart';
import '../../../domain/entities/nav_group.dart';
import '../../../domain/repositories/sidebar_repository.dart';

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
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/sidebar/presentation/controllers/
git commit -m "feat: add SidebarController with Riverpod state (collapse, expand groups, active item)"
```

---

## Task 6: SidebarItem widget

**Files:**
- Create: `lib/features/sidebar/presentation/widgets/sidebar_item.dart`

- [ ] **Step 1: Create `lib/features/sidebar/presentation/widgets/sidebar_item.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/nav_item.dart';
import '../controllers/sidebar_controller.dart';

class SidebarItemWidget extends ConsumerStatefulWidget {
  final NavItem item;
  final bool isCollapsed;

  const SidebarItemWidget({
    super.key,
    required this.item,
    required this.isCollapsed,
  });

  @override
  ConsumerState<SidebarItemWidget> createState() => _SidebarItemWidgetState();
}

class _SidebarItemWidgetState extends ConsumerState<SidebarItemWidget> {
  bool _isHovered = false;

  void _select() =>
      ref.read(sidebarControllerProvider.notifier).selectItem(widget.item.id);

  @override
  Widget build(BuildContext context) {
    final isActive =
        ref.watch(sidebarControllerProvider).activeItemId == widget.item.id;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isActive
        ? (isDark ? AppColors.activeItemBg : AppColors.lightActiveItemBg)
        : _isHovered
            ? (isDark ? AppColors.hoverItemBg : AppColors.lightHoverItemBg)
            : Colors.transparent;

    return Semantics(
      button: true,
      label: widget.item.label,
      selected: isActive,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (e) {
          if (e is KeyDownEvent &&
              e.logicalKey == LogicalKeyboardKey.enter) _select();
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: _select,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 2),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm + 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.itemRadius),
                color: bgColor,
                border: isActive
                    ? Border.all(
                        color: isDark
                            ? AppColors.neonGlow
                            : AppColors.lightTextActive,
                        width: 1,
                      )
                    : null,
                boxShadow: isActive && isDark
                    ? [
                        BoxShadow(
                          color: AppColors.neonGlow,
                          blurRadius: 10,
                          spreadRadius: 0,
                        )
                      ]
                    : null,
              ),
              child: widget.isCollapsed
                  ? Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? (isDark
                                  ? AppColors.textActive
                                  : AppColors.lightTextActive)
                              : (isDark
                                  ? AppColors.textMuted
                                  : AppColors.lightTextMuted),
                        ),
                      ),
                    )
                  : Text(
                      widget.item.label,
                      style: AppTypography.body.copyWith(
                        color: isActive
                            ? (isDark
                                ? AppColors.textActive
                                : AppColors.lightTextActive)
                            : (isDark
                                ? AppColors.textSecondary
                                : AppColors.lightTextSecondary),
                        fontWeight:
                            isActive ? FontWeight.w500 : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/sidebar/presentation/widgets/sidebar_item.dart
git commit -m "feat: add SidebarItem with hover, active, keyboard, and neon glow states"
```

---

## Task 7: SidebarGroup widget

**Files:**
- Create: `lib/features/sidebar/presentation/widgets/sidebar_group.dart`

- [ ] **Step 1: Create `lib/features/sidebar/presentation/widgets/sidebar_group.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/nav_group.dart';
import '../controllers/sidebar_controller.dart';
import 'sidebar_item.dart';

class SidebarGroupWidget extends ConsumerWidget {
  final NavGroup group;
  final bool isCollapsed;

  const SidebarGroupWidget({
    super.key,
    required this.group,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded =
        ref.watch(sidebarControllerProvider).expandedGroups.contains(group.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          button: true,
          label: '${group.label}, ${isExpanded ? 'recolher' : 'expandir'}',
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => ref
                  .read(sidebarControllerProvider.notifier)
                  .toggleGroup(group.id),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    if (!isCollapsed) ...[
                      Expanded(
                        child: Text(
                          group.label.toUpperCase(),
                          style: AppTypography.caption.copyWith(
                            color: isDark
                                ? AppColors.textMuted
                                : AppColors.lightTextMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.textMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: group.items
                .map(
                  (item) => SidebarItemWidget(
                    key: ValueKey(item.id),
                    item: item,
                    isCollapsed: isCollapsed,
                  ),
                )
                .toList(),
          ),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 220),
          sizeCurve: Curves.easeInOutCubic,
        ),
      ],
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/sidebar/presentation/widgets/sidebar_group.dart
git commit -m "feat: add SidebarGroup with animated expand/collapse and chevron rotation"
```

---

## Task 8: SidebarHeader widget

**Files:**
- Create: `lib/features/sidebar/presentation/widgets/sidebar_header.dart`

- [ ] **Step 1: Create `lib/features/sidebar/presentation/widgets/sidebar_header.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../controllers/sidebar_controller.dart';

class SidebarHeader extends ConsumerWidget {
  final bool isCollapsed;

  const SidebarHeader({super.key, required this.isCollapsed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
      child: Row(
        children: [
          _Logo(isDark: isDark),
          if (!isCollapsed) ...[
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Orion Docs',
                style: AppTypography.title.copyWith(
                  color: isDark
                      ? AppColors.textPrimary
                      : AppColors.lightTextPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(width: AppSpacing.sm),
          _CollapseButton(isCollapsed: isCollapsed),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final bool isDark;
  const _Logo({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: isDark
            ? [BoxShadow(color: AppColors.neonGlow, blurRadius: 12)]
            : null,
      ),
      child: const Icon(Icons.auto_stories_rounded,
          color: Colors.white, size: 17),
    );
  }
}

class _CollapseButton extends ConsumerWidget {
  final bool isCollapsed;
  const _CollapseButton({required this.isCollapsed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: isCollapsed ? 'Expandir menu' : 'Recolher menu',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () =>
              ref.read(sidebarControllerProvider.notifier).toggleCollapse(),
          child: AnimatedRotation(
            turns: isCollapsed ? 0.5 : 0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCubic,
            child: Icon(
              Icons.chevron_left_rounded,
              size: 20,
              color:
                  isDark ? AppColors.textMuted : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/sidebar/presentation/widgets/sidebar_header.dart
git commit -m "feat: add SidebarHeader with logo, title, and animated collapse toggle"
```

---

## Task 9: Root Sidebar widget

**Files:**
- Create: `lib/features/sidebar/presentation/widgets/sidebar.dart`

- [ ] **Step 1: Create `lib/features/sidebar/presentation/widgets/sidebar.dart`**

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../controllers/sidebar_controller.dart';
import 'sidebar_group.dart';
import 'sidebar_header.dart';

class AppSidebar extends ConsumerWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sidebarControllerProvider);
    final groups = ref.watch(sidebarGroupsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOutCubic,
      width: state.isCollapsed
          ? AppSpacing.sidebarCollapsed
          : AppSpacing.sidebarExpanded,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(AppSpacing.borderRadius),
          bottomRight: Radius.circular(AppSpacing.borderRadius),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.sidebarSurface
                  : AppColors.lightSidebarSurface,
              border: Border(
                right: BorderSide(
                  color: isDark
                      ? AppColors.sidebarBorder
                      : AppColors.lightSidebarBorder,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SidebarHeader(isCollapsed: state.isCollapsed),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.sidebarBorder
                      : AppColors.lightSidebarBorder,
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md),
                    itemCount: groups.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (_, i) => SidebarGroupWidget(
                      key: ValueKey(groups[i].id),
                      group: groups[i],
                      isCollapsed: state.isCollapsed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/features/sidebar/presentation/widgets/sidebar.dart
git commit -m "feat: add root AppSidebar with glassmorphism, animated width, and scrollable groups"
```

---

## Task 10: Update main.dart

**Files:**
- Modify: `lib/main.dart`

- [ ] **Step 1: Rewrite `lib/main.dart`**

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/sidebar/presentation/widgets/sidebar.dart';

void main() {
  runApp(const ProviderScope(child: OrionDocsApp()));
}

class OrionDocsApp extends StatelessWidget {
  const OrionDocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orion Docs',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const _AppShell(),
    );
  }
}

class _AppShell extends StatelessWidget {
  const _AppShell();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _AnimatedBackground(
        child: Row(
          children: [
            AppSidebar(),
            Expanded(child: _ContentPlaceholder()),
          ],
        ),
      ),
    );
  }
}

class _ContentPlaceholder extends StatelessWidget {
  const _ContentPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_stories_rounded,
            size: 48,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'Selecione um documento',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedBackground extends StatefulWidget {
  final Widget child;
  const _AnimatedBackground({required this.child});

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) {
        final t = _ctrl.value;
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.lerp(
                const Alignment(-0.9, -0.9),
                const Alignment(0.5, 0.5),
                t,
              )!,
              radius: 1.4,
              colors: [
                Color.lerp(AppColors.gradientStart, AppColors.gradientMid, t)!
                    .withOpacity(0.18),
                AppColors.darkBg,
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
```

- [ ] **Step 2: Run the app**

```bash
flutter run -d windows
```

Expected: App launches, dark animated gradient background visible, glass sidebar on the left with "Orion Docs" header. Clicking a group header expands it with smooth animation. Clicking an item highlights it with neon purple glow. Chevron button collapses sidebar to 64px.

- [ ] **Step 3: Commit**

```bash
git add lib/main.dart
git commit -m "feat: complete Orion Docs sidebar navigation — ProviderScope, AnimatedBackground, AppShell"
```
