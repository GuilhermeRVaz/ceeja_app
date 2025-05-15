// Este arquivo pode ser usado para constantes específicas do Supabase.
// No entanto, como já estamos usando flutter_dotenv e AppConfig para as chaves,
// e o cliente Supabase é acessível globalmente via Supabase.instance.client,
// este arquivo pode não ser estritamente necessário para constantes simples.
// Pode ser útil para nomes de tabelas, funções RPC, etc., se forem usados frequentemente.

class SupabaseConstants {
  // Exemplo de como você poderia usar este arquivo:
  // static const String usersTableName = "users";
  // static const String profilesTableName = "profiles";
  // static const String rpcFunctionName = "my_rpc_function";

  // Por enquanto, vamos mantê-lo simples, pois as chaves de API
  // estão sendo carregadas via .env e AppConfig.
}

