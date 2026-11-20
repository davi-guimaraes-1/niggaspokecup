-- Cole tudo isto no SQL Editor do Supabase e clique em Run.

create table players(
  id uuid primary key references auth.users on delete cascade,
  name text unique not null check (char_length(name) between 2 and 24),
  created_at timestamptz default now());

create table events(
  id uuid primary key default gen_random_uuid(),
  name text not null,
  creator uuid not null references players(id),
  mode text not null default 'roundrobin' check (mode in ('roundrobin','rounds')),
  rounds int,
  status text not null default 'open' check (status in ('open','running','finished')),
  champion uuid references players(id),
  created_at timestamptz default now());

create table entries(
  event_id uuid references events on delete cascade,
  player_id uuid references players,
  primary key (event_id, player_id));

create table matches(
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references events on delete cascade,
  round int not null,
  p1 uuid not null references players,
  p2 uuid not null references players,
  winner uuid references players,
  is_tiebreak boolean not null default false);

create table bets(
  id uuid primary key default gen_random_uuid(),
  match_id uuid not null references matches on delete cascade,
  player_id uuid not null references players,
  pick uuid not null references players,
  amount int not null check (amount > 0),
  odds numeric not null check (odds >= 1),
  payout int,
  created_at timestamptz default now());

-- Todo mundo lê tudo; escrever depende das regras abaixo.
do $$ declare t text; begin
  foreach t in array array['players','events','entries','matches','bets'] loop
    execute format('alter table %I enable row level security', t);
    execute format('create policy "leitura publica" on %I for select using (true)', t);
  end loop;
end $$;

create policy "jogador cria o proprio perfil" on players for insert with check (id = auth.uid());
create policy "jogador edita o proprio perfil" on players for update using (id = auth.uid());

create policy "qualquer jogador cria evento" on events for insert with check (creator = auth.uid());
create policy "so o criador altera o evento" on events for update using (creator = auth.uid());

create policy "inscrever-se com inscricoes abertas" on entries for insert
  with check (player_id = auth.uid() and exists (select 1 from events e where e.id = event_id and e.status = 'open'));
create policy "cancelar a propria inscricao" on entries for delete
  using (player_id = auth.uid() and exists (select 1 from events e where e.id = event_id and e.status = 'open'));

create policy "so o criador gerencia partidas" on matches for all
  using (exists (select 1 from events e where e.id = event_id and e.creator = auth.uid()))
  with check (exists (select 1 from events e where e.id = event_id and e.creator = auth.uid()));

create policy "apostar antes do resultado, fora da propria partida" on bets for insert
  with check (player_id = auth.uid() and payout is null and exists (
    select 1 from matches m where m.id = match_id and m.winner is null and auth.uid() not in (m.p1, m.p2)));
create policy "so o criador do evento liquida apostas" on bets for update
  using (exists (select 1 from matches m join events e on e.id = m.event_id where m.id = bets.match_id and e.creator = auth.uid()));
