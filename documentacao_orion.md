# Orion Docs — Documentação

## O que é o Orion Docs?

O **Orion Docs** é um gerador de documentos jurídicos e administrativos desenvolvido em Flutter. O app permite criar, preencher e exportar documentos em PDF com formatação profissional sem precisar de Word, advogado ou editor de texto.

Acesso web: **https://orion-docs-seven.vercel.app**

---

## Para que serve?

O Orion Docs agiliza a criação de documentos formais do dia a dia: contratos de aluguel, recibos, declarações para eventos e requerimentos. O usuário preenche apenas os campos necessários (nome, CPF, valor, datas etc.) e o app monta o documento automaticamente, pronto para impressão ou assinatura digital.

---

## Documentos disponíveis

### Contratos
| Documento | O que cobre |
|---|---|
| Contrato de Aluguel | Locação de imóvel entre locador e locatário |
| Contrato de Compra e Venda | Transferência de imóvel com condições de pagamento |
| Contrato de Doação | Doação de bem entre partes com assinatura de testemunhas |

### Recibos
| Documento | O que cobre |
|---|---|
| Recibo Simples | Comprovante de recebimento de valor genérico |
| Recibo de Aluguel | Comprovante de pagamento de aluguel mensal |
| Quitação Antecipada | *(template em desenvolvimento)* |
| Honorários Profissionais | *(template em desenvolvimento)* |

### Declarações para Eventos
| Documento | O que cobre |
|---|---|
| Conformidade Sonora | Autorização de festa com comunicação à Polícia Militar |
| Baixo Impacto | Declaração de evento de baixo impacto |
| Montagem de Estruturas | *(template em desenvolvimento)* |

### Declarações Administrativas
| Documento | O que cobre |
|---|---|
| Residência | *(template em desenvolvimento)* |
| Inexistência de Vínculo | *(template em desenvolvimento)* |
| Veracidade de Informações | *(template em desenvolvimento)* |

### Requerimentos
| Documento | O que cobre |
|---|---|
| Ligação Nova | Requerimento de nova ligação de água/energia |
| Mudança de Cavalete | *(template em desenvolvimento)* |

### Procurações
| Documento | O que cobre |
|---|---|
| Alteração de Titularidade | Procuração para alteração de titularidade de serviço |

---

## Como usar

### 1. Selecionar o documento
Na barra lateral esquerda, clique na categoria desejada (ex.: *Contratos*) e depois no documento (ex.: *Contrato de aluguel*). O formulário e a pré-visualização aparecem na tela.

### 2. Preencher os campos
No painel esquerdo, preencha todos os campos obrigatórios:
- **Texto**: nome, endereço, características do imóvel etc.
- **CPF**: digitado sem máscara, formatado automaticamente (ex.: `123.456.789-00`)
- **Telefone**: formatado automaticamente com DDD
- **Moeda**: valor numérico (ex.: `600,00`)
- **Data**: selecionada por calendário, exibida por extenso no documento

Os campos preenchidos aparecem em **negrito** no documento. Os campos ainda em branco aparecem em cinza como `[Nome do Campo]`.

### 3. Visualizar em tempo real
O painel direito exibe a pré-visualização do documento atualizada a cada alteração. É possível revisar o texto antes de gerar o PDF.

### 4. Gerar o PDF
Clique no botão **Gerar PDF** (canto inferior). O arquivo é baixado automaticamente no navegador (web) ou salvo na pasta de downloads (desktop).

### 5. Limpar e recomeçar
O botão **Limpar** apaga todos os campos preenchidos para iniciar um novo documento do mesmo tipo.

---

## Formatação do PDF

Os documentos gerados seguem as convenções de documentos jurídicos brasileiros:

- **Fonte**: Helvetica 12pt (equivalente ao Arial)
- **Margens**: 2,54 cm (padrão ABNT / Word "Normal")
- **Título**: centralizado, negrito
- **Parágrafos**: texto justificado, recuo de 0,5 cm na primeira linha
- **Cláusulas**: numeradas automaticamente — `Cláusula 1 – TÍTULO` (negrito, alinhado à esquerda)
- **Subcláusulas**: numeradas como `1.1`, `1.2` etc. (com leve recuo)
- **Subtítulos**: caixa alta, negrito, alinhado à esquerda
- **Assinaturas**: centralizadas — linha tracejada, nome em negrito, CPF em fonte normal

---

## Estrutura técnica (para desenvolvedores)

```
lib/
├── core/
│   ├── platform/         # Download de PDF (web / desktop)
│   └── theme/            # Cores, tipografia, espaçamentos
└── features/
    ├── sidebar/          # Navegação e seleção de documentos
    └── document_generator/
        ├── data/
        │   ├── datasources/   # Leitura dos templates JSON (assets/)
        │   ├── models/        # DocumentModel, FieldModel
        │   └── repositories/  # Implementação do repositório
        ├── domain/
        │   ├── entities/      # Document, Field, DocumentType
        │   ├── repositories/  # Interface do repositório
        │   └── usecases/      # LoadDocumentTemplate, GeneratePdf, UpdateFieldValue
        └── presentation/
            ├── pages/         # DocumentGeneratorPage
            ├── providers/     # Estado com Riverpod
            └── widgets/       # Formulário, pré-visualização, botões

assets/
└── templates/            # Um arquivo JSON por documento
```

### Templates JSON

Cada documento é definido por um arquivo JSON em `assets/templates/`:

```json
{
  "id": "contrato_aluguel",
  "title": "Contrato de Aluguel",
  "fields": [
    { "id": "nome_locador", "label": "Nome do Locador", "type": "text", "required": true }
  ],
  "template": "CONTRATO DE ALUGUEL\n\n[CLAUSULA] DO OBJETO DA LOCAÇÃO\n\nTexto com {{nome_locador}}..."
}
```

**Marcadores especiais no template:**
- `{{campo_id}}` — substituído pelo valor preenchido pelo usuário
- `[CLAUSULA] TÍTULO` — gera `Cláusula N – TÍTULO` numerado automaticamente
- `[SUBCLAUSULA] Texto` — gera `N.M Texto` numerado automaticamente
- `_____` em uma linha isolada — detectado como linha de assinatura

---

## Tecnologias utilizadas

| Tecnologia | Uso |
|---|---|
| Flutter | Framework principal (web + Windows) |
| Riverpod | Gerenciamento de estado |
| `pdf` package | Geração de PDF |
| CanvasKit (WASM) | Renderização web |
| Vercel | Hospedagem da versão web |
