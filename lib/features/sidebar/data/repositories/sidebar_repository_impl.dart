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
        NavGroup(id: 'suporte', label: 'Suporte', items: [
          NavItem(id: 'feedback', label: 'Reportar Bug / Sugestões'),
        ]),
      ];
}
