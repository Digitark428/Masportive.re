# Cap Homard — déploiement SaaS (Vercel + Supabase)

Application de gestion de tournois de beach-volley avec **connexion unique** et
**sauvegarde automatique dans le cloud**. Tous les appareils qui se connectent
avec le même identifiant retrouvent **exactement les mêmes tournois**.

## Connexion à l'application
- **Identifiant :** `volleypei`
- **Mot de passe :** `volleypei974`

Pas de création de compte, pas d'e-mail, pas de confirmation : on arrive, on se connecte, on utilise.

## Contenu du dossier
- `index.html` — l'application
- `api/config.js` — petite fonction Vercel qui fournit la config Supabase au navigateur
- `supabase_setup.sql` — à exécuter une fois dans Supabase

## Mise en place (≈ 5 min, une seule fois)

### 1. Supabase — base de données
1. Sur **supabase.com**, ouvre ton projet (ou crée-en un).
2. Menu **SQL Editor → New query** → colle le contenu de `supabase_setup.sql` → **Run**.
   > Cette version crée une **table partagée unique** `tournaments`
   > (colonnes : `id`, `created_at`, `updated_at`, `name`, `event_date`, `data`),
   > **sans** Supabase Auth ni `user_id`. Le champ `data` (JSON) contient tout le tournoi.

> ℹ️ Tu n'as **rien** à configurer dans **Authentication** : l'app n'utilise plus les comptes Supabase.

### 2. Vercel — variables d'environnement
Dans ton projet Vercel → **Settings → Environment Variables**, ajoute (si pas déjà fait) :
- `VITE_SUPABASE_URL`  = l'URL de ton projet Supabase (ex. `https://xxxx.supabase.co`)
- `VITE_SUPABASE_ANON_KEY` = la clé **anon / publishable** (Supabase → Settings → API Keys)

> Ces deux variables ne sont jamais saisies par l'utilisateur : la fonction `api/config.js` les lit côté serveur.

### 3. Déployer le dossier sur Vercel
Déploie **tout le dossier** `cap-homard/` (pas seulement le HTML), pour que `api/config.js` soit pris en compte :
- **Option simple** : vercel.com → **Add New… → Project → Deploy** en glissant le dossier, **ou**
- **Option Git** : mets le dossier dans un dépôt GitHub connecté à Vercel (redéploiement auto à chaque modif).

Après avoir ajouté les variables d'environnement, **redéploie** pour qu'elles soient prises en compte.

## Utilisation
1. Ouvre l'adresse `https://…vercel.app`.
2. Connecte-toi avec `volleypei` / `volleypei974`.
3. Au premier lancement, **aucun tournoi** n'est affiché. Crée-en autant que tu veux.
4. Chaque tournoi est **enregistré automatiquement** dans Supabase (indicateur « Synchronisé »).
   - création = enregistrement immédiat
   - modification (scores, équipes…) = mise à jour automatique
   - suppression = suppression immédiate dans Supabase
5. Sur un autre appareil (téléphone, tablette, PC), connecte-toi avec le **même identifiant** → tous tes tournois sont là.

## Notes
- L'app charge la librairie Supabase et la config au démarrage : une connexion Internet est nécessaire pour la synchro.
- En cas de coupure réseau, l'app continue en **local** (cache navigateur) et **resynchronise** ensuite automatiquement.
- L'URL et la clé « anon » sont publiques par conception.

### À savoir sur la sécurité
La connexion `volleypei` / `volleypei974` est un **verrou applicatif** (côté navigateur).
Comme l'app n'utilise pas Supabase Auth, la clé « anon » publique donne accès à la table partagée.
C'est volontaire et adapté à un usage interne (une seule équipe d'organisation).
Si tu veux un jour une vraie barrière d'accès, la méthode propre est de réactiver **un seul** compte
Supabase Auth caché derrière cet écran de connexion.

## En cas de problème (diagnostic)
L'app écrit des journaux dans la **console du navigateur** (**F12** → onglet *Console*) :
- `[cloud] config chargée…` : les variables Vercel sont bien lues.
- `[cloud] client prêt…` : la connexion Supabase fonctionne.
- `[cloud] chargement OK : N tournoi(s).` : les tournois ont bien été chargés au démarrage.
- `[cloud] ✅ upsert OK` : un tournoi a bien été enregistré dans Supabase.
- `[cloud] ❌ ERREUR upsert / delete : …` : affiche le message exact renvoyé par Supabase
  (message, details, hint, code) — utile si une colonne ou une policy ne correspond pas.

## Option : saisie des scores par les joueurs
Tu peux laisser les joueurs saisir eux-mêmes leurs scores depuis le live (le tournoi se remplit tout seul).

**Activation (une fois) :** dans Supabase → SQL Editor, exécute le fichier `supabase_add_player_entry.sql`.
> ✅ Sans risque : il ajoute juste une table `score_submissions`, il ne touche pas à tes tournois. (Inutile de ré-exécuter `supabase_setup.sql`, qui lui recrée la table des tournois.)

**Utilisation :**
1. Ouvre un tournoi → onglet **Live & partage** → active **« Saisie des scores par les joueurs »** (désactivé par défaut).
2. Les joueurs scannent le QR permanent, vont dans l'onglet **« Mon équipe »**, cherchent leur équipe et saisissent leurs scores.
3. Un message leur rappelle de remplir **avec l'équipe adverse, ensemble**.
4. Les scores arrivent **en direct** dans ton tournoi. Tu gardes toujours la main pour corriger via les pages d'admin habituelles.

> Désactivée, l'app fonctionne exactement comme avant (toi seul saisis les scores).
