import '../entities/nav_group.dart';

abstract class SidebarRepository {
  List<NavGroup> getGroups();
}
