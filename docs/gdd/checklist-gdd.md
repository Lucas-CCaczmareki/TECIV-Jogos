ISSO VAI VIRAR UM PROJECT NO GITHUB, P/ MANTER HISTÓRICO VIA ISSUES
# Checklist — Conteúdo do GDD

## 1. Visão geral / Conceito
- [ ] Título do jogo (mesmo que provisório)
- [ ] High concept (a frase-resumo)
- [ ] Gênero e subgênero
- [ ] Plataforma(s) alvo
- [ ] Público-alvo e classificação indicativa
- [ ] Referências/comparáveis ("é tipo X encontra Y")
- [ ] Unique Selling Points (o que diferencia do resto do mercado)

## 2. Gameplay (o coração do documento)
- [ ] Loop principal (o que o jogador faz repetidamente)
- [ ] Controles / inputs
- [ ] Objetivos (curto, médio e longo prazo)
- [ ] Condições de vitória e derrota
- [ ] Mecânicas centrais (detalhadas uma a uma)
- [ ] Mecânicas secundárias/sistemas de suporte (inventário, crafting, etc., se houver)
- [ ] Curva de dificuldade / progressão
- [ ] Economia do jogo (pontos, moedas, recursos), se aplicável

## 3. Personagens
- [ ] Protagonista (habilidades, motivação, arco)
- [ ] NPCs e antagonistas principais
- [ ] Inimigos/enemies (tipos, comportamento, IA básica)
- [ ] Progressão do personagem (upgrades, níveis, skill tree)

## 4. Mundo e narrativa
- [ ] Sinopse da história
- [ ] Ambientação/lore (contexto do universo)
- [ ] Estrutura narrativa (linear, ramificada, ambiental)
- [ ] Divisão de fases/níveis/mundos
- [ ] Descrição de cada fase-chave (o que muda em termos de gameplay)

## 5. Level design
- [ ] Estrutura de progressão entre fases
- [ ] Tipos de desafios/puzzles por fase
- [ ] Ritmo (onde o jogo acelera, onde respira)
- [ ] Mapa ou fluxograma de níveis (visual, tipo o "flowchart" do Rogers)

## 6. Interface (UI/UX)
- [ ] HUD (o que aparece na tela durante o jogo)
- [ ] Menus (principal, pause, configurações)
- [ ] Feedback visual/sonoro pro jogador (dano, coleta de itens, etc.)

## 7. Arte
- [ ] Direção de arte / referências visuais
- [ ] Paleta de cores
- [ ] Estilo (pixel art — resolução dos sprites, tamanho de tile, etc.)
- [ ] Concept art de personagens, cenários, itens

## 8. Áudio# Brainstorm de ideias

- Jogo com câmera de cima estilo enter the gungeon

- Combate twin stick shooter, um analógico controla movimentação, outro mira. Arma e combate tático à distância (similar à enter the gungeon)

- Presença de um companion controlável. Menu de controle de ações com Y que desacelera o tempo pra tomar decisões estratégicas. Ex de mecânicas:
    Default
    - Esquivar: o companion esquiva das balas do inimigo pros lados
    - Atacar: escolhe um alvo e o companion ataca corpo a corpo

    Com cooldown
    - Atrair: o companion atrai o foco dos inimigos da sala.
    - Restringir: o companion restringe movimentos e ataques de um inimigo.
    - Curar
    - Trocar de lugar (?)

- Vida do companion ligada à vida do personagem principal. Ambos morrem quando a barra de vida de algum dos dois zerar. Barras de vida separada

- Mecânica de arma modular trocável (fora de combate). Inicia com uma pistola simples e tempo de recarga. Conforme encontra peças/power ups permite alterar o disparo da arma (e quantas balas utiliza).  Ex: 
    - pistola (inicial)
    - Shotgun dispara 3-5 balas em cone. 
    - Sniper carrega e dispara um tiro forte. 
    - Rifle dispara várias balas rápidas em sequência mas sem
    - Arco, similar à sniper porém permite disparar várias flechar rápidas carregando menos
    - etc...

- Mecânica de rolagem pra esquivar de balas. Similar à enter the gungeon, dark souls. Rolagem mais punitiva por que vai ter menos balas.
Então rolou pra dentro de um projétil, tomou dano.

- Progressão de nível estilo action rpg?

- Salas progressivas, algumas com perigos e obstáculos (estilo soul knight, espinhos no chão, lasers com timing, etc). Outras salas com disposição tática de objetos e combate contra 1 inimigo forte, N (vários) inimigos fracos, 1 inimigo forte a alguns fracos...
    ### A decididir: 
    - A depender do gênero podem ser geradas linearmente (com checkpoints)
    - Podem ser geradas de maneira aleatória até encontrar a sala do boss (estilo roguelike).
    - Pode ser um mapa explorável simples (estilo hyper light drifter)

- Presença de 1 chefão principal: finaliza o jogo. E um chefão intermediário.

- Tutorial em 2 partes: 
    - inicia apenas com personagem principal, luta contra alguns inimigos simples e depois morre pro chefão final. Liga com prólogo da história do jogo.

    - apṕos morrer, encontra companion. Uma ou duas salas para entender as mecânicas escolhidas do companion.

- Nome do jogo: beastbond

- História básica: local dungeon ou reino, vários guerreiros enfrentam o chefe final. Todos que falham morrem e ficam presos nesse local por toda eternidade **(precisamos pensar numa motivação pra esse vilão e pras pessoas e nosso protagonista enfrentá-lo)**. Jogador começa morrendo e perdendo uma das mãos e vira um esqueleto, encontra lobo espectral **(vai ser necessário pensar na história e motivação dele)**  e oferece o osso do braço pra ele. Lobo liga a vida dele ao player oferecendo um braço espectral que permite controlá-lo e bom, usar um braço. Osso do braço vira a arma do lobo que segura como se fosse uma espada (estilo Sif do dark souls). Jogador encontra vários personagens com diferenciais (sla, tipo robo de lata, arvore falante, etc) que vão ser os npcs do jogo. Um dos npcs se mostra o boss intermediário **(vai ser necessário pensar na história e motivação dele)**.

    - Progressão de nível com checkpoint encaixa melhor que roguelike e continua escalável. Mas ainda vai ser necessário decidir

- Ideias de temática:
    - Medieval/Steampunk? (precisa justificar armas de fogo)
    - Sombria: inspirado em dark souls?
    - Dungeon: similar à dungeon meshi só que sem a parte da comida? 
    

- Mercador vende poções de cura.
- Companion libera habilidade de consumir poção do inventário pra te curar automaticamente.
- camera fixa no personagem igual hyper light drifter (mas divide em áreas e projeta separado)
- mecanica de trocar de lugar com o companion.

- [ ] Estilo de trilha sonora
- [ ] Efeitos sonoros principais
- [ ] Referências de trilha (se já tiver em mente)

## 9. Técnico
- [ ] Engine/ferramenta usada (Unity, Godot, etc.)
- [ ] Requisitos técnicos mínimos
- [ ] Escopo (o que é viável dentro do prazo da disciplina)

## 10. Produção
- [ ] Cronograma / milestones
- [ ] Equipe e responsabilidades (se for em grupo)
- [ ] Riscos e como mitigar (escopo grande demais, falta de tempo, etc.)
