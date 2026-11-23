# Beastbond
**Disciplina:** TECIV: Jogos Digitais <br>
**Alunos:** Lucas Cavallin Caczmareki e Gustavo dos Santos Leon <br>
**Professor:** Rafael P. Torchelsen


## Sobre o jogo
*Beastbond* é um action-RPG top-down / twin-stick shooter em que o jogador controla, ao mesmo tempo, um personagem principal e um companion (lobo), gerenciando combate, posicionamento e vidas separadas dos dois em um mapa explorável com progressão de dificuldade, misturando salas com obstáculos, combates e puzzles.

A visão completa do projeto (gênero, plataformas, high concept, personagens, mecânicas e puzzles) está no [`docs/GDD.html`](docs/GDD.html). Esse é o ponto de partida pra entender o jogo. Como o jogo ainda está em construção, algumas partes dos documentos aparentarão estar incompletas.

## Estrutura atual do projeto

```
TECIV-Jogos/
├── docs/
│   ├── GDD.html                  Game Design Document (o quê e por quê do jogo)
│   ├── TDD.html                  Technical Design Document (como o jogo é organizado + cronograma)
│   ├── Pitch.pdf                 Apresentação do pitch
│   ├── Teaser.md                 Link do vídeo de teaser
│   └── brainstorm.md             Registro livre de ideias em discussão
├── assets/                       art/, fonts/, sounds/, sprites/
├── scenes/                       Cenas do Godot (.tscn)
│   ├── atk_scenes/               Ataques: balas (bullets/), laser, slash
│   ├── characters/               Player, Companion, Slime
│   ├── huds/                     HUDs de jogo
│   ├── interactables/            Chest, Door, Lever, ItemCollidable
│   ├── weapons/                  Armas (player_weapons/ + melee)
│   ├── world/                    Chunks e ChunkManager
│   └── World.tscn                Cena raiz
├── scripts/                      Scripts GDScript (.gd), espelha a pasta scenes/
│   ├── atk_scenes/               AtkScene, Bullet, Laser, Slash
│   ├── characters/               Character, Player, Companion, componentes (Health, Stamina, Hurtbox)
│   ├── huds/                     Scripts das HUDs
│   ├── interactables/            Interactable e derivados
│   ├── weapons/                  Weapon, RangedWeapon, MeleeWeapon, WeaponManager, WeaponPivot
│   ├── world/                    Scripts das chunks
│   ├── events.gd                 Autoload Events (barramento global de signals)
│   ├── camera_2d.gd              Câmera do Player (limites vindos do ChunkManager)
│   ├── chunk_manager.gd
│   ├── hud_manager.gd
│   └── world.gd
├── icon.svg                      Ícone do projeto
└── project.godot                 Arquivo de projeto do Godot
```

## Documentação
- **[`docs/GDD.html`](docs/GDD.html)**: o jogo em si (visão geral, personagens, controles, armas, inimigos, power-ups, níveis, puzzles, HUDs, narrativa).
- **[`docs/TDD.html`](docs/TDD.html)**: a organização técnica (princípios de arquitetura, hierarquia de classes, comunicação entre sistemas, combate e dano, armas, player, lobo, inimigos, itens, mundo, interface, áudio) e o **cronograma** de marcos de cada um (L1 a L12 e G1 a G11).
- **[`docs/Pitch.pdf`](docs/Pitch.pdf)** e **[`docs/Teaser.md`](docs/Teaser.md)**: material de apresentação.
- **[`docs/brainstorm.md`](docs/brainstorm.md)**: ideias soltas sobre a concepção do jogo

### Visualizando os arquivos `.html`
O GitHub não renderiza `.html` como página. Ele sempre mostra o código-fonte (por segurança). Pra ver como página de verdade, baixe o arquivo (ou clone o repositório) e abra no navegador. As imagens já vêm embutidas dentro do próprio `.html`, então o arquivo isolado funciona. As fontes vêm do Google Fonts, então sem internet a página abre com a fonte padrão.

## Stack técnica
- **Engine:** Godot 4.7
- **Linguagem:** GDScript

## Divisão de responsabilidades
| Área | Responsável |
|---|---|
| Personagens, mecânicas, IAs de inimigos, HUD/UI, menus | Lucas |
| Level design, progressão, economia, bossfights, puzzles, narrativa | Gustavo |
| Documentação (`.md`), entregáveis da disciplina (GDD, slides), arte e áudio | Ambos, cada um faz a parte correspondente à sua área |

## Cronograma e progresso
Os marcos vêm do cronograma do [TDD](docs/TDD.html). **◆** marca os marcos críticos (os outros dependem deles). Legenda: ✅ feito · 🔶 em andamento · ⬜ não iniciado.

### Lucas: personagens, mecânicas, IA, HUD/UI e menus
| Marco | Entrega | Status | Observação |
|---|---|:---:|---|
| L1 ◆ | Base de combate | ✅ | HealthComponent, StaminaComponent, Character, Hurtbox, take_damage, layers e masks, Projectiles, Events |
| L2 ◆ | Armas de fogo | ✅ | setup/try_attack/reload, mira vinda do dono, WeaponManager com 2 slots, SMG, Sniper e Shotgun. Multiplicadores de arma e `equip()` esperam os itens (G3) e o inventário (L11) |
| L3 | Armas melee | ⬜ | Espada com combo, Lança, Explosion. Entra logo depois do `Enemy` base |
| L4 ◆ | Player completo | ✅ | Vida, stamina, sprint, esquiva com `airborne`, morte, inputs novos, Camera2D. A câmera só recebe limites quando o ChunkManager (G2) emitir `camera_bounds_changed` |
| L5 ◆ | Enemy base e IA | ✅ | Próximo marco: Hitbox, `Enemy`, percepção, `stun`/`freeze`, migrar o Slime, DropTable |
| L6 | Inimigos de contato | ⬜ | Slime com divisão, Soldado A, Tank, Investida |
| L7 | Inimigos à distância e suporte | ⬜ | Soldado B, Sniper, Sacerdote |
| L8 ◆ | Lobo em combate | 🔶 | FOLLOW, HOLD e DEAD funcionam. Faltam Hitbox, ATTACK, ordens e interação com alavanca e placa |
| L9 | Menu do lobo | ⬜ | WolfCommandController, câmera lenta, Vínculo, 4 skills |
| L10 | HUDs de jogo | 🔶 | HudManager com `bind_weapon` e HUD de munição. Faltam barras de vida e stamina, consumível e barras no mundo |
| L11 | Inventário | ⬜ | Inventory e tela com arrastar e soltar |
| L12 | Menus e fluxo de telas | ⬜ | Main, menu principal, pause, controles, game over |

### Gustavo: level design, progressão, itens, boss, puzzles e narrativa
Estado levantado a partir do que existe no repositório. O Gustavo confirma e ajusta.

| Marco | Entrega | Status | Observação |
|---|---|:---:|---|
| G1 ◆ | Room e PuzzleController | 🔶 | Chest, Lever, Door e ItemCollidable na base Interactable. Faltam Room e PuzzleController |
| G2 ◆ | Game e ChunkManager | 🔶 | ChunkManager instancia a chunk inicial. Faltam autoload Game, troca de chunk com fade, checkpoint e respawn |
| G3 ◆ | Itens e power-ups | ⬜ | ItemData, ItemDB, Pickup, drops, altares |
| G4 | Chunk 1 | ⬜ | Layout final com combate, cobertura, lobo, altar e checkpoint |
| G5 | Puzzles 1 e 2 | ⬜ | Canal de esgoto e Lobo com alavanca |
| G6 | Puzzle 3 | ⬜ | Totens alinhados com a Sniper |
| G7 | Chunk 2 | ⬜ | Combate misto, hazards, altar e preparação para o boss |
| G8 | Boss: base e fases | ⬜ | Herança de Enemy, troca de fases, arena trancada |
| G9 | Boss: ataques | ⬜ | Padrões das fases 2 e 3, inimigos extras |
| G10 | Cutscenes e narrativa | ⬜ | CutsceneData, diálogo, abertura, final, créditos |
| G11 | Áudio | ⬜ | AudioManager, faixas por estado, SFX faltantes |

### Fases
| Fase | Marcos | Resultado jogável | Situação |
|---|---|---|:---:|
| 1. Fundação | L1, L2, L4, G1, G2 | Jogador com vida e stamina atira e leva dano; sala que tranca e abre; troca de chunk | 🔶 (lado do Lucas concluído) |
| 2. Conteúdo | L3, L5 a L9, G3 a G6 | Chunk 1 completa, com lobo, inimigos, itens e puzzles | ⬜ |
| 3. Integração | L10 a L12, G7 a G10 | Chunk 2, boss, inventário, menus, cutscenes | ⬜ |
| 4. Polimento | G11 e ajustes | Áudio, balanceamento, correções e teste completo de ponta a ponta | ⬜ |

Se o tempo apertar, o TDD manda cortar nesta ordem: Bomber, eco do boss, Pulso temporal, Lança, skill Restringir.