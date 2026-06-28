-- ============================================================
--  Cap Homard — base de données (à exécuter UNE fois)
--  Supabase → SQL Editor → coller → Run
-- ============================================================

create table if not exists public.tournaments (
  id text primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  updated_at bigint not null default 0,
  payload jsonb not null
);

alter table public.tournaments enable row level security;

-- Chaque utilisateur ne voit et ne modifie QUE ses propres tournois
drop policy if exists "select_own" on public.tournaments;
drop policy if exists "insert_own" on public.tournaments;
drop policy if exists "update_own" on public.tournaments;
drop policy if exists "delete_own" on public.tournaments;

create policy "select_own" on public.tournaments
  for select to authenticated using (auth.uid() = user_id);
create policy "insert_own" on public.tournaments
  for insert to authenticated with check (auth.uid() = user_id);
create policy "update_own" on public.tournaments
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "delete_own" on public.tournaments
  for delete to authenticated using (auth.uid() = user_id);
