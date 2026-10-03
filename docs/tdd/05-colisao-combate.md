# 05 — Colisão e combate

> Esta área **ainda não foi planejada**. O documento registra o estado atual e deixa uma proposta inicial para discussão.

## Estado atual

| Item | Status |
|---|---|
| Nomes de layers no `project.godot` | [ABERTO] não configurados |
| `collision_layer` / `collision_mask` nas cenas | [ABERTO] nenhuma cena define, então tudo usa o padrão (layer 1, mask 1) |
| Colisão do player com paredes das chunks | [PARCIAL] `CharacterBody2D` × `StaticBody2D` funcionam por estarem no padrão |
| Colisão de balas do player | [PARCIAL] `Area2D` existe na `Bullet`, sem signal nem filtro |
| Balas inimigas | [PLANEJADO] |
| Ataques corpo a corpo inimigos | [PLANEJADO] |
| Trigger de troca de chunk | [PLANEJADO] ver [02](02-chunk-manager.md#troca-de-chunk-) |

## Tipos de interação a cobrir

1. Player/companion x paredes e objetos sólidos
2. Bala do player x inimigos (e paredes)
3. Bala inimiga x player/companion (e paredes)
4. Ataque corpo a corpo inimigo x player/companion
5. Ataque corpo a corpo do companion x inimigos
6. Player x trigger de chunk / porta / item

## [SUGESTÃO] Proposta de layers

Ponto de partida. Nomear em *Project Settings -> Layer Names -> 2D Physics* para não trabalhar com números soltos.

| # | Nome | O que é |
|---|---|---|
| 1 | `world` | Paredes e obstáculos sólidos |
| 2 | `player` | Corpo do player |
| 3 | `companion` | Corpo do companion |
| 4 | `companion_hitbox` | Área de ataque corpo a corpo do companion |
| 5 | `player_projectile` | Balas do player/companion |
| 6 | `enemy` | Corpo dos inimigos |
| 7 | `enemy_projectile` | Balas inimigas |
| 8 | `enemy_hitbox` | Área de ataque corpo a corpo inimigo |
| 9 | `trigger` | Triggers de chunk, portas, itens |

Quem **enxerga** o quê (mask):

| Nó | Layer | Mask |
|---|---|---|
| Player | `player` | `world`, `enemy`, `companion` |
| Companion | `companion` | `world`, `enemy`, `player` |
| Hitbox do companion | `companion_hitbox` | `enemy` |
| Bala do player | `player_projectile` | `world`, `enemy` |
| Bala inimiga | `enemy_projectile` | `world`, `player`, `companion` |
| Hitbox inimiga | `enemy_hitbox` | `player`, `companion` |
| Inimigo | `enemy` | `world`,  `player`, `companion` |
| Trigger de chunk | `trigger` | `player` |

## Conexão com as regras de jogo

- **Sem i-frames no dodge** (decisão em [03](03-player-companion.md#dodge-)): o corpo/hurtbox do player continua ativo enquanto rola. Não desligar colisão durante o dodge.
- **Vida separada, derrota compartilhada** (player e companion): o dano precisa chegar ao dono certo, o que pesa na escolha da interface de dano abaixo.

## Decisões em aberto

- [ABERTO] **Como o dano é aplicado:** método `take_damage(amount)` no alvo, signal `hit` emitido pela bala/hitbox, ou componente de vida reaproveitável (`HealthComponent`)?
- [ABERTO] **Hurtbox separada:** o player usa um `Area2D` próprio para receber dano, ou o próprio `CollisionShape2D` do corpo?
- [ABERTO] Quem destrói a bala ao colidir (a própria bala ou quem recebeu o dano)?
- [ABERTO] Tempo de vida da bala (hoje nenhum).
- [ABERTO] Hitbox do ataque corpo a corpo do companion (mesma estrutura dos inimigos?).
