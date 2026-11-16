// Configuração do projeto Supabase MenuRadar IA.
// A chave publishable/anon pode ser usada no navegador; nunca use service_role/secret aqui.
export const SUPABASE_URL = "https://paeswogpyktwyxobpypy.supabase.co";
export const SUPABASE_ANON_KEY = "sb_publishable_GrTqDdhSdatIgL3oOubCGQ_tu0kvLu0";
export const isSupabaseConfigured = () =>
  SUPABASE_URL.startsWith("https://") &&
  !SUPABASE_URL.includes("COLE_") &&
  !SUPABASE_ANON_KEY.includes("COLE_");
