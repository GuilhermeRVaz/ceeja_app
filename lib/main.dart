import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ceeja_app/core/navigation/app_router.dart';
import 'package:ceeja_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:ceeja_app/env.dart'; // Importar o arquivo env.dart

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carregar variáveis de ambiente do arquivo .env
  await dotenv.load(fileName: 'assets/.env');

  // Inicializar Supabase com as variáveis do env.dart
  await Supabase.initialize(
    url: AppEnv.supabaseUrl,
    anonKey: AppEnv.supabaseAnonKey,
    // A service_role key não é passada diretamente aqui.
    // Ela será usada internamente pelo AuthProvider para operações administrativas.
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
          create:
              (_) => AuthProvider(
                supabaseClient: Supabase.instance.client,
                serviceRoleKey: AppEnv.supabaseServiceRoleKey,
              ),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final authProvider = Provider.of<AuthProvider>(
              context,
              listen: false,
            );
            return EnrollmentProvider(
              adminSupabaseClient: authProvider.adminSupabaseClient,
            );
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'CEEJA de Lins App',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        locale: const Locale('pt', 'BR'),
      ),
    );
  }
}
