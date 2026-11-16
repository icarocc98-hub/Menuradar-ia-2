// Configure este arquivo com os dados do seu projeto Supabase.
// Dashboard Supabase > Project Settings > API.
// Use somente a chave publishable/anon no navegador. Nunca coloque service_role aqui.
export const SUPABASE_URL = "COLE_A_URL_DO_SEU_PROJETO";
export const SUPABASE_ANON_KEY = "COLE_SUA_CHAVE_PUBLICA_AQUI";
export const isSupabaseConfigured = () =>
  SUPABASE_URL.startsWith("https://") &&
  !SUPABASE_URL.includes("COLE_") &&
  !SUPABASE_ANON_KEY.includes("COLE_");
