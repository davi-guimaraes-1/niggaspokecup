# Pokecup: passo a passo

O site tem duas partes que trabalham juntas:

- **GitHub:** guarda e mostra as páginas do site (o arquivo `index.html`).
- **Supabase:** guarda os dados (jogadores, campeonatos, partidas, apostas). É de graça.

Você já colocou o site no GitHub. Falta **ligar o site ao Supabase**. São 4 etapas.

## Etapa 1: criar o banco de dados no Supabase

1. Entre em [supabase.com](https://supabase.com), crie uma conta e clique em **New project**. Dê um nome (ex.: pokecup), crie uma senha qualquer e escolha a região mais próxima (South America, se tiver).
2. Espere uns 2 minutos até o projeto ficar pronto.
3. No menu da esquerda, clique em **SQL Editor** e depois em **New query**.
4. Abra o arquivo `schema.sql`, copie **todo** o conteúdo, cole no editor e clique em **Run**. Deve aparecer "Success".

## Etapa 2: deixar os amigos criarem conta direto

1. No menu da esquerda, vá em **Authentication** e procure a configuração do provedor **Email** (fica em *Providers* ou *Sign In / Providers*).
2. Desligue a opção **Confirm email** e salve. Sem isso, cada amigo teria que confirmar o e-mail antes de entrar.

## Etapa 3: copiar as duas chaves para o site

1. No Supabase, clique no ícone de engrenagem (**Project Settings**) e depois em **API** (ou **API Keys**).
2. Copie a **Project URL** (parece com `https://abcdefgh.supabase.co`).
3. Copie a chave **anon** (um texto bem longo que começa com `eyJ`). Em versões novas do painel, ela fica na aba **Legacy API Keys**.
4. No GitHub, abra seu repositório, clique no arquivo `index.html` e depois no ícone de **lápis** (Edit).
5. Perto do começo do código, ache estas duas linhas e troque os textos entre aspas pelo que você copiou:

```js
const SB_URL = 'COLE_AQUI_A_URL', SB_KEY = 'COLE_AQUI_A_CHAVE_ANON';
```

   Fica assim (exemplo):

```js
const SB_URL = 'https://abcdefgh.supabase.co', SB_KEY = 'eyJhbGciOi...';
```

6. Clique em **Commit changes** (botão verde) e confirme.
7. Espere 1 ou 2 minutos e abra o site apertando **Ctrl + F5** (no celular, feche e abra a aba). A tela de login deve aparecer.

Pode colar essa chave sem medo: ela é feita para ficar pública. Quem protege os dados são as regras do `schema.sql`.

## Etapa 4: usar

1. Cada pessoa clica em **Criar conta** (nome, e-mail e senha) e depois em **Entrar**.
2. Quem for organizar cria o campeonato; os outros se inscrevem; o criador encerra as inscrições, o chaveamento é gerado e ele registra os resultados.

## Importar a 1ª PokeCup (opcional)

Depois que os 5 jogadores criarem conta com os nomes certos, abra `importar_primeira_pokecup.sql`, troque o nome em `v_criador` (quem organizou), cole no **SQL Editor** e clique em **Run**. Rode só uma vez.

## Regras do sistema

- Vitória vale 1 ponto, derrota 0. Todos jogam a mesma quantidade de partidas.
- Com número ímpar de inscritos e a opção de rodadas, o número de rodadas precisa ser múltiplo do número de inscritos.
- Empate no topo gera automaticamente uma partida de desempate pelo 1º lugar.
- Apostas: saldo inicial 1000, só para competidores do evento, na rodada atual e nunca na própria partida. As odds vêm do histórico de vitórias de cada jogador e ficam fixas na hora da aposta.

## Se algo der errado

- **Página em branco ou mensagem de erro:** confira se as duas chaves foram coladas inteiras, entre aspas, e se você apertou Ctrl + F5.
- **"Row-level security" ou "permission denied":** o `schema.sql` não foi executado até o fim. Rode de novo num projeto novo.
- **Limitações:** o limite de saldo nas apostas é checado só no site, e resultados já registrados só podem ser corrigidos pelo painel do Supabase.
