## Cronograma/milestones

1. **Fechar GDD:** escopo, fluxo dos dois chunks, boss único, power-ups e tutorial integrado.
2. **Fechar TDD:** árvore de cenas, troca de chunk, pause/tutorial, checkpoints e drops.
3. **Vertical slice:** entrada, combate básico, lobo, um power-up e transição para o Chunk 2.
4. **Mapa completo:** dois chunks jogáveis e checkpoint.
5. **Boss:** arena, fases, vitória e retorno após derrota.
6. **Feira:** controles visíveis, pause funcional, tutorial consultável, build estável e teste com pessoas externas.

O critério de prioridade é: jogabilidade completa antes de arte, narrativa detalhada ou conteúdo opcional.

---
## Responsabilidades de cada integrante
- 1 (Ambos): Documentação, apresentação, cronogramas, teaser, versão mínima do jogo, manutenção do board do github
- 2 (Gustavo): Level Design, mapa, progressão, itens, power-ups, boss, salas, encontros e obstáculos
- 3 (Gustavo): História curta, narrativa ambiental, boss e nomes dos personagens
- 4 (Lucas): Personagens principais (protagonista e lobo), mecânicas, armas, habilidades, inimigos, IAs
- 5 (Lucas): HUD, menu, salvamento, UI/UX, etc
- 6 (Ambos): Arte, cenários, design, paleta de cres, concept arts
- 7 (Ambos): Audio, soundtracks, soundeffects

*na parte onde ambos são responsáveis, cada um é responsável pela própria parte desenvolvida. Ex: Lucas programou as armas, então Lucas é responsável pelo sound effect delas*

---
## Riscos e mitigação

| Risco | Mitigação |
|---|---|
| Escopo crescer durante a produção | Não adicionar NPCs, moedas, boss extra ou novos chunks |
| Jogador não entender os controles | Mostrar controles no pause e oferecer tutorial consultável |
| Pessoa abandonar a partida na feira | Manter a partida em 10–15 minutos e checkpoints claros |
| Mapa ficar repetitivo | Alternar combate, obstáculos, respiro e power-ups |
| Chunk descarregada perder progresso | Manter apenas duas cenas e um estado simples de partida |
| Boss consumir o prazo | Fazer primeiro uma versão de uma fase e adicionar variações depois |