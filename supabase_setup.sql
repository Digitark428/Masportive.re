-- ============================================================
--  Cap Homard — base de données (architecture SIMPLIFIÉE)
--  Supabase → SQL Editor → New query → coller → Run
--
--  • Une seule table partagée « tournaments »
--  • PAS de Supabase Auth, PAS de comptes e-mail, PAS de user_id
--  • La connexion à l'app est globale (identifiant/mot de passe dans l'app)
--  ⚠️ Ceci REMPLACE l'ancienne table (qui contenait user_id + RLS par utilisateur).
-- ============================================================

drop table if exists public.tournaments cascade;

create table public.tournaments (
  id          text primary key,                   -- identifiant du tournoi (généré par l'app)
  created_at  timestamptz not null default now(), -- date de création (auto)
  updated_at  timestamptz not null default now(), -- dernière modification (envoyée par l'app à chaque sauvegarde)
  name        text,                               -- nom du tournoi
  event_date  text,                               -- date affichée, texte libre (ex. « 14 juin 2026 »)
  data        jsonb not null                      -- LE TOURNOI COMPLET au format JSON (équipes, poules, scores, finales…)
);

-- Index pour trier rapidement par date de mise à jour
create index if not exists tournaments_updated_at_idx on public.tournaments (updated_at desc);

-- ------------------------------------------------------------
--  Sécurité au niveau des lignes (RLS)
--  L'app se connecte avec la clé « anon » publique (sans Supabase Auth),
--  on autorise donc une lecture/écriture complète de la table partagée.
-- ------------------------------------------------------------
alter table public.tournaments enable row level security;

drop policy if exists "acces_global" on public.tournaments;
create policy "acces_global" on public.tournaments
  for all
  to public          -- couvre les rôles anon et authenticated
  using (true)
  with check (true);
