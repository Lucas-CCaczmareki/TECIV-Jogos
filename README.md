# Beastbond
**Disciplina:** TECIV: Jogos Digitais <br>
**Alunos:** Lucas Cavallin Caczmareki e Gustavo dos Santos Leon <br>
**Professor:** Rafael P. Torchelsen


## Sobre o jogo
*Beastbond* é um action-RPG top-down / twin-stick shooter em que o jogador controla, ao mesmo tempo, um personagem principal e um companion (lobo), gerenciando combate, posicionamento e vidas separadas dos dois em um mapa explorável com progressão de dificuldade, misturando salas com obstáculos, combates e puzzles.

A visão completa do projeto (gênero, plataformas, high concept e referências) está em [`docs/gdd/content/`](docs/gdd/content/01-visao-geral.md). Esse é o ponto de partida pra entender o jogo. Como o jogo ainda está em construção, vários documentos aparentarão estarem incompletos.

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
│   └── tdd/                      
│       ├── ...                   arquivos descrevendo a organização atual e planejando
├── scenes/                       Cenas do Godot (.tscn)
│   ├── characters/               
│   ├── huds/                     
│   ├── weapons/                  
│   ├── world/
│   └── World.tscn                Cena raiz                      
├── scripts/                      Scripts GDScript (.gd)
│   ├── huds/                     
│   ├── weapons/                  
│   ├── player.gd
│   ├── chunk_manager.gd
│   ├── hud_manager.gd
│   └── world.gd                Cena raiz                      
├── icon.svg                      Ícone do projeto
└── project.godot                 Arquivo de projeto do Godot
```

## Documentação
A documentação é dividida em duas camadas:

- **`docs/gdd/content/`** e **`docs/gdd/narrative/`**. Cada arquivo cobre um tema específico (gameplay, personagens, narrativa, etc).
- **`docs/gdd/1-onepager.html`, `2-tenpager.html`, `3-gdd.html`** são versões formatadas e resumidas, compiladas a partir do conteúdo acima, pensadas pra entrega/apresentação na disciplina.
- **`docs/tdd`**. Cada arquivo cobre um tema específico quanto à organização do projeto (MainSceneTree, Colisão, Comunicação entre scripts, Hierarquia de classes)

### Visualizando os arquivos `.html`
O GitHub não renderiza `.html` como página. Ele sempre mostra o código-fonte (por segurança). Pra ver como página de verdade:
1. **Clone o repositório inteiro** e abra o arquivo localmente no navegador. As imagens usam caminhos relativos (`../art/...`), então elas só aparecem se a pasta `docs/art/` estiver junto. Baixar só o `.html` isolado não vai funcionar.
2. **Futuramente** os `.html` serão disponibilizados como `.pdf`, não sendo necessária a clonagem do repositório inteiro para visualização do documento.

## Stack técnica
- **Engine:** Godot
- **Linguagem:** GDScript

## Divisão de responsabilidades
| Área | Responsável |
|---|---|
| Personagens, mecânicas, IAs de inimigos, HUD/UI, menus | Lucas |
| Level design, progressão, economia, bossfights, puzzles, narrativa | Gustavo |
| Documentação (`.md`), entregáveis da disciplina (GDD, slides), arte e áudio | Ambos, cada um faz a parte correspondente à sua área |

