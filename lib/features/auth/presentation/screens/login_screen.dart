import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Para AuthException
import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ceeja_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:ceeja_app/core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String? fullName,
    bool isLogin,
  ) async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? errorMessage;

    try {
      final response = await authProvider.signInWithPassword(email, password);
      if (response?.user != null) {
        // Sucesso
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login bem-sucedido! Redirecionando...'),
              backgroundColor: Colors.green,
            ),
          );
          // Navegar para a tela principal após login bem-sucedido
          // context.go('/home'); // Descomente quando a rota /home existir
          print(
            "Login bem-sucedido, usuário: ${response?.user?.id}",
          ); // Mantendo para depuração
        }
      } else {
        // Isso não deveria acontecer se a exceção não for lançada, mas é uma segurança
        errorMessage = 'Falha no login. Resposta inesperada.';
      }
    } on AuthException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
      print('Erro não AuthException no login: $e'); // Mantendo para depuração
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ), // Correção: removido '!' desnecessário
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGreyColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Text(
                'Bem-vindo ao CEEJA de Lins',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Acesse sua conta para continuar',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AuthForm(
                submitFn: _submitAuthForm,
                isLogin: true,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: const Text(
                  'Não tem uma conta? Cadastre-se',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
