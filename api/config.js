// Fonction Vercel — renvoie la configuration publique Supabase au navigateur.
// L'URL et la clé "anon" sont des valeurs PUBLIQUES : il est normal de les exposer côté client.
// L'app utilise une connexion globale (identifiant/mot de passe défini dans l'app),
// sans Supabase Auth : l'accès à la table partagée est régi par la policy RLS "acces_global".
export default function handler(req, res) {
  res.setHeader('Cache-Control', 'no-store');
  res.status(200).json({
    url: process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL || '',
    anonKey: process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || ''
  });
}
