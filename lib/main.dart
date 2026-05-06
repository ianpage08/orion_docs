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
          const Icon(
            Icons.auto_stories_rounded,
            size: 52,
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
                Color.lerp(
                  AppColors.gradientStart,
                  AppColors.gradientMid,
                  t,
                )!.withValues(alpha: 0.18),
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
