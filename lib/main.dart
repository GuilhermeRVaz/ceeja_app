import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // IMPORTANTE: Verifique se este import existe

import 'package:ceeja_app/core/navigation/app_router.dart';
import 'package:ceeja_app/core/theme/app_theme.dart';
import 'package:ceeja_app/env.dart';

Future<void> main() async {
  // Garante que os bindings do Flutter sejam inicializados.
  WidgetsFlutterBinding.ensureInitialized();

  // PASSO 1 (CORRIGIDO): Carregar as variáveis de ambiente do arquivo .env PRIMEIRO.
  // Certifique-se que você tem um arquivo chamado '.env' dentro de uma pasta 'assets'
  // e que este arquivo está listado no seu pubspec.yaml na seção 'assets'.
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    print("Erro ao carregar o arquivo .env: $e");
    // Você pode querer parar a execução aqui se o .env for essencial
  }

  // PASSO 2 (CORRIGIDO): AGORA inicializar o Supabase, pois as variáveis já foram carregadas.
  await Supabase.initialize(
    url: AppEnv.supabaseUrl,
    anonKey: AppEnv.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

// O resto do arquivo MyApp permanece o mesmo.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
    );
  }
}
