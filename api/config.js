// Fonction Vercel — renvoie la configuration publique Supabase au navigateur.
// L'URL et la clé "anon" sont des valeurs PUBLIQUES : il est normal et sûr de les exposer,
// l'accès aux données étant protégé par la sécurité au niveau des lignes (RLS) + l'authentification.
export default function handler(req, res) {
  res.setHeader('Cache-Control', 'no-store');
  res.status(200).json({
    url: process.env.VITE_SUPABASE_URL || process.env.SUPABASE_URL || '',
    anonKey: process.env.VITE_SUPABASE_ANON_KEY || process.env.SUPABASE_ANON_KEY || ''
  });
}
