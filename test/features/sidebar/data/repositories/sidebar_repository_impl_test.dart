import 'package:flutter_test/flutter_test.dart';
import 'package:orion_docs/features/sidebar/data/repositories/sidebar_repository_impl.dart';

void main() {
  const repo = SidebarRepositoryImpl();

  group('SidebarRepositoryImpl', () {
    test('returns 7 groups', () {
      expect(repo.getGroups().length, 7);
    });

    test('last group is suporte', () {
      final last = repo.getGroups().last;
      expect(last.id, 'suporte');
      expect(last.label, 'Suporte');
    });

    test('suporte group contains feedback item', () {
      final suporte = repo.getGroups().last;
      expect(suporte.items.length, 1);
      expect(suporte.items.first.id, 'feedback');
      expect(suporte.items.first.label, 'Reportar Bug / Sugestões');
    });

    test('all group ids are unique', () {
      final ids = repo.getGroups().map((g) => g.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('all item ids within each group are unique', () {
      for (final group in repo.getGroups()) {
        final ids = group.items.map((i) => i.id).toList();
        expect(ids.toSet().length, ids.length,
            reason: 'Group ${group.id} has duplicate item ids');
      }
    });

    test('existing groups are preserved', () {
      final ids = repo.getGroups().map((g) => g.id).toList();
      expect(ids, containsAll(['contratos', 'recibos', 'decl_eventos', 'decl_adm', 'requerimentos', 'procuracoes']));
    });
  });
}
