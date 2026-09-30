# 03 — Player e Companion

**Cena:** `scenes/characters/Player.tscn` · **Script:** `scripts/player.gd` (`CharacterBody2D`)

## [PLANEJADO] Ciclo de vida

O `Player` é instanciado **uma vez** pelo `World` e vive durante todo o jogo. Como é filho do `World` (e não de uma chunk), **sobrevive à troca de chunks** sem precisar salvar/restaurar dados. O `Companion` segue a mesma lógica.

## Árvore da cena

```
Player (CharacterBody2D)            [player.gd]
├── AnimatedSprite2D                animações walk_/idle_/dodge_ × up/down/left/right
├── CollisionShape2D
├── WeaponPivot (Node2D)            [weapon_pivot.gd]  → ver 04
│   └── (arma ativa, instanciada em runtime)
└── ReloadBar (TextureProgressBar)  invisível até um reload começar
```

O nó entra no grupo **`"player"`** em `_enter_tree()`. Outros nós usam `get_tree().get_first_node_in_group("player")` para achá-lo.

## Responsabilidades

| Mecânica | Status |
|---|---|
| Movimento (WASD, `move_and_slide`) | [OK] |
| Dodge | [OK] |
| Animação baseada na posição do mouse | [OK] |
| Barra de reload sobre o player | [OK] |
| Gerenciar a arma modular (via `WeaponPivot`) | [PARCIAL] só equipa a arma inicial |
| Troca de arma (`_switch_weapon`) | [PLANEJADO] |
| Vida do player (barra própria) | [PLANEJADO] |

## Exports

| Variável | Valor padrão | Observação |
|---|---|---|
| `speed` | 240.0 | |
| `dodge_speed` | `speed * 2` | calculado na declaração |
| `dodge_duration` | 0.60 s | |
| `dodge_cooldown` | 0.20 s | conta **depois** que o dodge termina |

## [OK] Dodge

1. Só é possível **enquanto há input de movimento**.
2. Ao apertar `dodge` (com `can_dodge`): guarda a direção, dispara os timers, emite **`dodge_started`**, esconde a arma e toca a animação `dodge_<direção>`.
3. Enquanto `is_dodging`, a `velocity` é sobrescrita por `dodge_direction * dodge_speed`.
4. Ao fim de `dodge_duration`: emite **`dodge_ended`** e mostra a arma de novo.
5. O cooldown só começa a contar após o fim do dodge.

**Sem i-frames.** É decisão de mecânica (até então 21/08/26): rolar pra dentro de um projétil causa dano.
A direção da animação de dodge usa o eixo X primeiro, então rolagens diagonais usam a animação lateral.

[RESOLVER]: às vezes o movimento normal fica bloqueado na direção em que o dodge foi feito.

## [OK] Animação

- Direção (`up/down/left/right`) vem da **posição do mouse** em relação ao player, não da direção de movimento.
- Estado: `dodge_*` > `walk_*` (com input) > `idle_*`.
- Olhando pra cima, o sprite vai pra `z_index = 1` (uma camada acima); nas outras direções volta a 0.

## Input actions usadas

| Action | Usada por |
|---|---|
| `ui_left/right/up/down` | `player.gd` (movimento) |
| `dodge` | `player.gd` |
| `fire` | `revolver.gd` |
| `reload` | `revolver.gd` |

## [PARCIAL] Barra de reload

Fluxo atual: a arma emite `reload_started(duration)`, o player conecta (em `_ready`, via `weapon_pivot.get_weapon()`), mostra a `ReloadBar` e conta o tempo **por conta própria** em `_process`.

[RESOLVER] Isso significa **dois cronômetros** para a mesma coisa (um na arma, outro no player). Hoje estão sincronizados porque partem juntos, mas podem divergir. O `reload_finished` na arma está comentado; é ele que resolveria isso. Ver [04](04-weapon-system.md) e [07](07-comunicacao.md).

## [PLANEJADO] Companion 

O `Companion` (lobo) ainda não existe. O que já está decidido:

- Cena instanciada como o `Player`, **viva durante todo o jogo**, filha do `World`, para os dados sobreviverem entre chunks.
- Jogador comanda **ação** (ataque, defesa, esquiva...) e **movimentação** (livre, segue o player, fixo num ponto...).
- Vida própria; a perda de qualquer um dos dois encerra a run.
- Pode receber upgrades de arma, como o player.

[RESOLVER] Hoje `Weapon` descobre o dono com `get_first_node_in_group("player")`. Uma arma no companion acabaria ligada ao dodge do **player**. Antes de dar arma ao companion, o dono precisa ser descoberto de outro jeito (por exemplo, `owner`/`get_parent()` na cadeia, ou receber a referência por export/método). Ver [04](04-weapon-system.md#dependência-do-dono-da-arma).

[ABERTO] O que o `Player` e o `Companion` compartilham (vida, movimento, dano) define se faz sentido uma classe base. Ver [08](08-hierarquia-de-classes.md).

[ABERTO] Como o `Companion` é posicionado na troca de chunk/entrada de sala avulsa (teleportado junto com o player?).
