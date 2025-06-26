import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // MUDANÇA: Importa o Riverpod
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart'; // MUDANÇA: Importa o provider do Riverpod
import 'package:ceeja_app/features/auth/presentation/widgets/auth_form.dart';
import 'package:ceeja_app/core/theme/app_theme.dart';

// MUDANÇA: Converte de StatefulWidget para ConsumerStatefulWidget
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  // MUDANÇA: Converte para ConsumerState
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _isLoading = false;

  Future<void> _submitAuthForm(
    String email,
    String password,
    String? fullName,
    bool isLogin,
  ) async {
    // Validação simples para garantir que o nome não é nulo no cadastro
    if (fullName == null || fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha o nome completo.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // MUDANÇA: Usa ref.read para acessar o notifier do provider
    final authNotifier = ref.read(authProvider.notifier);
    String? errorMessage;

    try {
      // Supondo que você tenha um método `signUp` no seu AuthNotifier.
      // Este método deve ser chamado aqui.
      await authNotifier.signUp(email, password, fullName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Cadastro realizado com sucesso! Verifique seu e-mail para confirmação.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.goNamed('login');
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
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
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
                onPressed:
                    _isLoading
                        ? null
                        : () {
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
