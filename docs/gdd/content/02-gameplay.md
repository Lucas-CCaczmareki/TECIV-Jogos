<!-- TODO: @Gustavo preencher essa seção -->
## Core loop (ação repetida principal)

---
<!-- TODO: @Lucas pensar, analisar e preencher essa seção -->
## Controles/inputs
Movimentação: WASD ou Analógico direito
Mira: Mouse ou Analógico esquerdo<br>
**Por enquanto o resto fica N/A**<br>
Recarregar:
Usar itens:
Abrir mapa:
... etc

---
<!-- TODO: @Gustavo preencher essa seção -->
## Objetivos de curto, médio e longo prazo

---
<!-- TODO: @Gustavo terminar de preencher se necessário -->
## Condições de vitória e derrota
Personagem OU Companion tem a barra de vida reduzida à 0. Retornam pro último checkpoint

---
## Descrição funcional das mecânicas centrais

---
### Combate
- Combate à distância com câmera top-down.
- Uso tático de objetos/paredes do mapa para evitar projéteis.
- Arma com munição limitada e tempo de recarga.
- Esquiva/rolagem para escapar de projéteis/golpes.
- Companion age conforme comandos. Quando não comandado, age com uma IA simples que prefere a ação indicada pelo jogador.

---
### Arma modular
- Arma pode alternar funcionamento; troca de funcionamento tem cooldown.
- Diferentes tipos de arma possuem cadência de tiro, tipo/espaçamento de bala, tempo de recarga, dano, precisão e alcance distintos.
- O jogador pode manter até 2 tipos de funcionamento na arma ao mesmo tempo.
- A troca de funcionamento só pode ser feita fora de combate.
- Novos tipos de arma são desbloqueados via progressão.

| Tipo         | Cadência | Dano  | Recarga | Precisão | Alcance | Projétil |
|--------------|----------|-------|---------|----------|---------|----------|
| Revólver     | Média    | Baixo | Rápida  | Média    | Médio   | Simples  |
| Arco         | N/A      | N/A   | N/A     | N/A      | N/A     | N/A      |
| Sniper       | N/A      | N/A   | N/A     | N/A      | N/A     | N/A      |
| Escopeta     | N/A      | N/A   | N/A     | N/A      | N/A     | N/A      |
| Rifle        | N/A      | N/A   | N/A     | N/A      | N/A     | N/A      |
| Metralhadora | N/A      | N/A   | N/A     | N/A      | N/A     | N/A      |

*Revólver é a arma inicial. Demais tipos ainda não definidos.*

---
### Companion
- Controlado por IA simples.
- Menu contextual permite controlar ações do companion e o estilo de combate da IA.
- Ações do companion interagem com o inimigo de forma diferente das do jogador.
- Ataque do companion é corpo a corpo; esquiva do companion é lateral.
- Fora de combate, o companion evita perigos e obstáculos automaticamente e segue o jogador.
- Abrir o menu contextual desacelera o tempo. O uso do menu tem tempo limite ou cooldown entre usos, com indicação visual para o jogador.
- O companion tem limite de ações e de movimento que consegue executar dentro do menu contextual.

**Menu contextual**

| Categoria | Ações |
|---|---|
| Ações base | Mover · Esquivar (dash ou rolagem) · Atacar · Ficar parado (desativa a IA)? |
| Habilidades especiais (limite de 2) | Trocar de posição · Curar jogador · Restringir/atordoar inimigo · Atrair inimigos |

---
### Vida
- Barras de vida separadas para jogador e companion.
- Caso alguma das vidas zere, o jogador E o companion morrem, retornando ao último checkpoint.

---
### Esquiva
- Funciona como uma rolagem para qualquer direção.
- A colisão com um projétil ou golpe causa dano — a rolagem não torna o jogador invencível.

---
### Inimigos
- Barra de vida exibida no topo da cabeça.
- Comportamento controlado por IA.

**Atributos gerais:** dano, vida, velocidade de movimento, tamanho... (outros a definir)

| Inimigo | Movimento | Ataque | Dano | Status |
|---|---|---|---|---|
| Inimigo 1 | Move-se em direção ao jogador lentamente | Corpo a corpo | Baixo | Definido |
| Inimigo 2 | Move-se em direção ao jogador lentamente | À distância | Baixo | Definido |
| Inimigo 3, 4, 5... | — | — | — | Ainda não desenvolvidos |

---
<!-- TODO: @Gustavo preencher isso aqui -->
### Itens:
Por enquanto N/A. Caso a gente acabe desenvolvendo itens, tipo granadas, powerups específicos, etc.
Ou coisas que modifiquem a gameplay, iremos indicar aqui.

---
### Estrutura de salas:
(como as salas se conectam, o que define o layout de uma área — linear, ramificado, com bifurcações)

---
### Navegação e orientação:
(como o jogador sabe pra onde ir — minimapa, landmarks visuais, HUD de direção, ou "sem guia" tipo HLD)

---
### Portas e bloqueios:
(o que tranca uma sala/área — chave, puzzle resolvido, boss derrotado, item específico)

---
### Interatividade do cenário:
(baús, alavancas, objetos destrutíveis, obstáculos que o personagem/companion podem usar ou precisar desviar)

---
### NPCs resgatáveis:
(onde aparecem, condição de resgate, o que desbloqueiam no hub)

---
### Hub principal:
(o que existe nele — loja, upgrade, poções — e como o jogador entra/sai dele em relação ao mapa)

---
### Checkpoints e persistência:
(o que salva progresso dentro de uma run, o que reseta ao morrer, o que é permanente entre runs)

---
### Verticalidade e hazards do terreno:
(se existem armadilhas, buracos, terrenos que causam dano ou limitam movimento, plataformas)

---
<!-- TODO: @Gustavo preencher essa seção -->
## Economia do jogo (moedas, recursos), se houver
