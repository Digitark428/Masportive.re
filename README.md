# Cap Homard — déploiement SaaS (Vercel + Supabase)

Application de gestion de tournois de beach-volley avec **comptes utilisateurs** et
**sauvegarde automatique dans le cloud**. Chaque utilisateur retrouve ses tournois
depuis n'importe quel appareil en se connectant avec le même compte.

## Contenu du dossier
- `index.html` — l'application
- `api/config.js` — petite fonction Vercel qui fournit la config Supabase au navigateur
- `supabase_setup.sql` — à exécuter une fois dans Supabase

## Mise en place (≈ 10 min, une seule fois)

### 1. Supabase — base de données
1. Sur **supabase.com**, ouvre ton projet (ou crée-en un).
2. Menu **SQL Editor** → **New query** → colle le contenu de `supabase_setup.sql` → **Run**.
   > ⚠️ Cette version **recrée** la table `tournaments` au bon format (colonnes `id` texte, `data`, `name`, `event_date`, `updated_at`). Comme la table était vide, rien n'est perdu. C'était la cause de l'erreur 400.

### 2. Supabase — comptes (e-mail / mot de passe)
1. Menu **Authentication → Sign In / Providers** : vérifie que **Email** est activé.
2. Pour une connexion **immédiate** (sans e-mail de confirmation) :
   **Authentication → Providers → Email** → désactive **« Confirm email »**.
   (Si tu le laisses activé, les nouveaux comptes devront cliquer un lien reçu par e-mail avant de se connecter.)

### 3. Vercel — variables d'environnement
Dans ton projet Vercel → **Settings → Environment Variables**, ajoute (si pas déjà fait) :
- `VITE_SUPABASE_URL`  = l'URL de ton projet Supabase (ex. `https://xxxx.supabase.co`)
- `VITE_SUPABASE_ANON_KEY` = la clé **anon / publishable** (Supabase → Settings → API Keys)

> Ces deux variables ne sont jamais saisies par l'utilisateur : la fonction `api/config.js` les lit côté serveur.

### 4. Déployer le dossier sur Vercel
Déploie **tout le dossier** `cap-homard/` (et pas seulement le fichier HTML), pour que `api/config.js` soit pris en compte :
- **Option simple** : sur vercel.com → **Add New… → Project → Deploy** en glissant le dossier, **ou**
- **Option Git** : mets le dossier dans un dépôt GitHub et connecte-le à Vercel (redéploiement automatique à chaque modif).

Après déploiement, **redéploie** si tu viens d'ajouter les variables d'environnement (pour qu'elles soient prises en compte).

## Utilisation
1. Ouvre l'adresse `https://…vercel.app`.
2. **Crée un compte** (e-mail + mot de passe), ou connecte-toi.
3. Crée un tournoi → il est **enregistré automatiquement** dans le cloud (indicateur « Synchronisé »).
4. Sur un autre appareil, connecte-toi avec le **même compte** → tous tes tournois sont là.

## Notes
- L'app charge la librairie Supabase et la config au démarrage : une connexion Internet est nécessaire.
- En cas de coupure réseau, l'app continue en local et resynchronise ensuite.
- L'URL et la clé « anon » sont publiques par conception ; la sécurité repose sur l'authentification + les règles RLS du fichier SQL (chacun ne voit que ses tournois).


## En cas de problème (diagnostic)
L'app écrit des journaux détaillés dans la **console du navigateur** (touche **F12** → onglet *Console*) :
- `[cloud] config chargée…` : les variables Vercel sont bien lues.
- `[cloud] utilisateur connecté : …` : l'auth fonctionne.
- `[cloud] ✅ upsert OK` : un tournoi a bien été enregistré dans Supabase.
- `[cloud] ❌ ERREUR upsert Supabase : …` : affiche le **message exact** renvoyé par Supabase (message, details, hint, code) — utile si une colonne ou une policy ne correspond pas.

Si tu vois encore une erreur, ouvre la console (F12), reproduis, et envoie-moi la ligne `❌ ERREUR` complète.
