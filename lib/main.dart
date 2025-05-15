import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ceeja_app/core/navigation/app_router.dart';
import 'package:ceeja_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carregar variáveis de ambiente do arquivo .env
  await dotenv.load(fileName: ".env");

  // Inicializar Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(supabaseClient: Supabase.instance.client),
        ),
        // Outros providers podem ser adicionados aqui
      ],
      child: MaterialApp.router(
        title: 'CEEJA de Lins App',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
