-- ============================================================
--  Cap Homard — base de données (à RÉ-exécuter : remet la table au bon format)
--  Supabase → SQL Editor → coller → Run
--  ⚠️ La table actuelle est vide : on la recrée proprement pour qu'elle
--     corresponde exactement au code (id texte, colonne data, RLS par utilisateur).
-- ============================================================

drop table if exists public.tournaments cascade;

create table public.tournaments (
  id          text primary key,                 -- identifiant du tournoi (généré par l'app)
  user_id     uuid not null default auth.uid()  -- propriétaire
              references auth.users(id) on delete cascade,
  name        text,                             -- nom du tournoi
  event_date  text,                             -- date (texte libre, ex. "14 juin 2026")
  data        jsonb not null,                   -- tournoi complet (équipes, poules, scores, finales…)
  updated_at  bigint not null default 0,        -- horodatage pour la fusion multi-appareils
  created_at  timestamptz not null default now()
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
