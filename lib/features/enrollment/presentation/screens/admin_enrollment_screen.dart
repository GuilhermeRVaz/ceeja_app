// lib/features/enrollment/presentation/screens/admin_enrollment_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';

// Importe seus widgets de formulário aqui. Se eles também usarem providers,
// precisarão ser convertidos para ConsumerWidget.
import 'package:ceeja_app/features/enrollment/presentation/widgets/personal_data_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/address_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/schooling_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/documents_form.dart';

// MUDANÇA: Converte para ConsumerStatefulWidget para usar 'ref' e gerenciar Controllers.
class AdminEnrollmentScreen extends ConsumerStatefulWidget {
  const AdminEnrollmentScreen({super.key});

  @override
  ConsumerState<AdminEnrollmentScreen> createState() =>
      _AdminEnrollmentScreenState();
}

class _AdminEnrollmentScreenState extends ConsumerState<AdminEnrollmentScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Seus outros controllers...

  // Mantém um estado de loading local para o botão de submit.
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitAdminEnrollment() async {
    setState(() => _isSubmitting = true);

    // MUDANÇA: Acessa os notifiers dos providers usando 'ref.read'.
    final authNotifier = ref.read(authProvider.notifier);
    final enrollmentNotifier = ref.read(enrollmentProvider.notifier);

    // MUDANÇA: Acessa os dados dos formulários a partir do estado do enrollmentProvider.
    final personalData = ref.read(enrollmentProvider).personalData;

    try {
      // 1. Criar a conta do novo aluno no Supabase Auth
      // A lógica de criação de usuário foi movida para o AuthNotifier.
      // Supondo que exista um método `createStudentUser` lá.
      final User newStudentUser = await authNotifier.createStudentUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: personalData.nomeCompleto ?? '', // Garante que não seja nulo
      );

      final String newStudentUserId = newStudentUser.id;
      print('Novo aluno criado com ID: $newStudentUserId');

      // 2. Salvar os Dados da Matrícula associados ao ID do Novo Aluno
      // O método `submitEnrollment` no EnrollmentNotifier agora lida com tudo.
      await enrollmentNotifier.submitEnrollment();

      print('Dados da matrícula do aluno salvos com sucesso!');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aluno cadastrado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        // Opcional: Limpar formulários ou navegar para outra tela
      }
    } catch (e) {
      print('Erro ao cadastrar aluno: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao cadastrar aluno: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Garante que o estado de loading seja desativado, mesmo se ocorrer um erro.
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observa o estado de autenticação para garantir que apenas admins vejam a tela.
    final authState = ref.watch(authProvider);

    if (authState.userRole != 'administrador') {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text(
            'Acesso negado. Esta área é apenas para administradores.',
          ),
        ),
      );
    }

    // Se for admin, mostra o formulário.
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Novo Aluno')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campos para e-mail e senha do novo aluno
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail do Aluno'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha Temporária do Aluno',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),

            // Reutilize seus widgets de formulário existentes.
            // Eles precisam ser ConsumerWidgets se precisarem ler/modificar o enrollmentProvider.
            PersonalDataForm(),
            const SizedBox(height: 20),
            AddressForm(),
            const SizedBox(height: 20),
            SchoolingForm(),
            const SizedBox(height: 20),
            DocumentsForm(),
            const SizedBox(height: 30),

            ElevatedButton(
              // Desabilita o botão enquanto estiver submetendo.
              onPressed: _isSubmitting ? null : _submitAdminEnrollment,
              child:
                  _isSubmitting
                      ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                      : const Text('Cadastrar Aluno'),
            ),
          ],
        ),
      ),
    );
  }
}
