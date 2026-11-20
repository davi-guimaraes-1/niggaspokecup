# Pokecup

Site para torneios de Pokémon Showdown entre amigos. O site é estático (GitHub Pages) e os dados ficam no Supabase (gratuito).

## Configuração

1. Crie um projeto em [supabase.com](https://supabase.com).
2. Em **SQL Editor**, cole o conteúdo de `schema.sql` e clique em **Run**.
3. Em **Authentication > Providers > Email**, desative **Confirm email** (assim seus amigos entram direto após criar a conta).
4. Em **Project Settings > API**, copie a **Project URL** e a chave **anon public**.
5. No início do `index.html`, substitua `SB_URL` e `SB_KEY` por esses dois valores. A chave anon é pública por design: quem protege os dados são as regras do `schema.sql`.

## Publicação no GitHub Pages

1. Crie um repositório no GitHub e envie `index.html`, `schema.sql` e `README.md`.
2. Em **Settings > Pages**, escolha **Deploy from a branch**, branch `main`, pasta `/ (root)`.
3. Em alguns minutos o site fica em `https://SEU-USUARIO.github.io/NOME-DO-REPOSITORIO/`.

## Regras implementadas

- Qualquer pessoa logada cria campeonatos; o criador encerra as inscrições e registra os resultados.
- Chaveamento: todos contra todos ou número fixo de rodadas. Com número ímpar de inscritos, as rodadas precisam ser múltiplo do número de inscritos (senão alguém jogaria menos).
- Vitória vale 1 ponto, derrota 0. Empate no topo gera automaticamente uma partida de desempate pelo 1º lugar (se forem mais de 2 empatados, um todos contra todos entre eles, repetido até sobrar um).
- Apostas: saldo inicial de 1000, apenas competidores do evento, apenas na rodada atual e nunca na própria partida. A odd é calculada pela taxa de vitórias de cada jogador em todos os eventos (com suavização para novatos) e fica fixa no momento da aposta. O pagamento é feito quando o criador registra o resultado.
- A página **Vencedores** conta as Pokecups (campeonatos vencidos) de cada jogador.

## Limitações conhecidas

- O limite de saldo nas apostas é checado só no site, não no banco. Para amigos funciona, mas não é à prova de quem editar o código no navegador.
- Resultados registrados não podem ser corrigidos pelo site (só editando a tabela `matches` no painel do Supabase).
