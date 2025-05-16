import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Para AuthException
import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ceeja_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:ceeja_app/core/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String? fullName,
    bool isLogin, // Não usado diretamente aqui, pois é sempre cadastro
  ) async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? errorMessage;

    try {
      final response = await authProvider.signUp(
        email,
        password,
        data: {'full_name': fullName ?? ''},
      );

      if (response?.user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Cadastro realizado com sucesso! Verifique seu e-mail para confirmação (se habilitado).',
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Usar goNamed é uma boa prática se você nomeou suas rotas.
          context.goNamed('login');
        }
      } else {
        errorMessage = 'Falha no cadastro. Resposta inesperada.';
      }
    } on AuthException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
      print('Erro não AuthException no cadastro: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      if (errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor:
                Colors.red, // Corrigido: removido '!' desnecessário
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGreyColor,
      appBar: AppBar(
        title: const Text('Criar Nova Conta'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.whiteColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Insira seus dados para criar uma conta',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AuthForm(
                submitFn: _submitAuthForm,
                isLogin: false, // Modo de cadastro
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Usar goNamed é uma boa prática se você nomeou suas rotas.
                  context.goNamed('login');
                },
                child: const Text(
                  'Já tem uma conta? Faça login',
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
