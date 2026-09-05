# Beastbond

**Disciplina:** TECIV — Jogos Digitais
**Alunos:** Lucas Cavallin Caczmareki · Gustavo dos Santos Leon
**Professor:** Rafael P. Torchelsen

## Sobre o jogo

*Beastbond* é um action-RPG top-down / twin-stick shooter em que o jogador controla, ao mesmo tempo, um personagem principal e um companion (lobo), gerenciando combate, posicionamento e vidas separadas dos dois em um mapa explorável com progressão de dificuldade, misturando salas com obstáculos, combates e puzzles.

A visão completa do projeto (gênero, plataformas, high concept e referências) está em [`docs/gdd/content/`](docs/gdd/content/01-visao-geral.md). Esse é o ponto de partida pra entender o jogo.

## Estrutura atual do projeto

```
TECIV-Jogos/
├── docs/
│   ├── art/                      Concept arts e assets visuais
│   ├── brainstorm.md             Registro livre de ideias em discussão
│   └── gdd/
│       ├── 1-onepager.html       One Page Design Document (visão resumida, 1 página)
│       ├── 2-tenpager.html       Ten Page Design Document (versão intermediária)
│       ├── 3-gdd.html            GDD completo (versão navegável/compilada)
│       ├── checklist-gdd.md      Checklist de progresso da documentação
│       ├── content/   ...        Conteúdo-fonte do GDD, um arquivo por tema
│       └── narrative/ ...        Narrativa detalhada
├── scenes/                       Cenas do Godot (.tscn)
├── scripts/                      Scripts GDScript (.gd)
├── icon.svg                      Ícone do projeto
└── project.godot                 Arquivo de projeto do Godot
```

## Documentação

A documentação é dividida em duas camadas:

- **`docs/gdd/content/`** e **`docs/gdd/narrative/`** — a fonte de verdade. Cada arquivo cobre um tema específico (gameplay, personagens, narrativa, etc). Seções ainda não preenchidas ficam marcadas com um TODO indicando de quem é a responsabilidade, ex:
  ```markdown
  <!-- TODO: @Gustavo preencher essa seção -->
  ```
- **`docs/gdd/1-onepager.html`, `2-tenpager.html`, `3-gdd.html`** — versões formatadas e resumidas, compiladas a partir do conteúdo acima, pensadas pra entrega/apresentação na disciplina.

### Visualizando os arquivos `.html`

O GitHub não renderiza `.html` como página — ele sempre mostra o código-fonte (por segurança). Pra ver como página de verdade:

1. **Clone o repositório inteiro** e abra o arquivo localmente no navegador. As imagens usam caminhos relativos (`../art/...`), então elas só aparecem se a pasta `docs/art/` estiver junto — não adianta baixar só o `.html` isolado.
<!-- 2. Alternativamente, ative o **GitHub Pages** do repositório (Settings → Pages) pra publicar como site navegável. -->

## Stack técnica

- **Engine:** Godot
- **Linguagem:** GDScript

## Divisão de responsabilidades

| Área | Responsável |
|---|---|
| Personagens, mecânicas, IAs de inimigos, HUD/UI, menus | Lucas |
| Level design, progressão, economia, bossfights, puzzles, narrativa | Gustavo |
| Documentação (`.md`), entregáveis da disciplina (GDD, slides), arte e áudio | Ambos, cada um faz a parte correspondente à sua área |

