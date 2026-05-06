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
