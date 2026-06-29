-- ============================================================
--  MIGRATION — Saisie des scores par les joueurs
--  À exécuter UNE fois dans Supabase → SQL Editor → Run.
--  ✅ Sans risque : n'ajoute qu'une table, ne touche PAS à tes tournois existants.
-- ============================================================
create table if not exists public.score_submissions (
  id             bigint generated always as identity primary key,
  tournament_id  text not null,
  slot           text not null,
  score_a        int  not null,
  score_b        int  not null,
  created_at     timestamptz not null default now()
);

create index if not exists score_submissions_tid_idx on public.score_submissions (tournament_id, created_at);

alter table public.score_submissions enable row level security;

drop policy if exists "submissions_global" on public.score_submissions;
create policy "submissions_global" on public.score_submissions
  for all to public using (true) with check (true);
