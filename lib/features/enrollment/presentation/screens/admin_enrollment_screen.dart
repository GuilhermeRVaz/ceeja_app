import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
// Importe seus modelos de dados (PersonalDataModel, AddressModel, etc.)
import 'package:ceeja_app/features/enrollment/domain/models/personal_data_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/address_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/schooling_model.dart';
import 'package:ceeja_app/features/enrollment/domain/models/documents_model.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/personal_data_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/address_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/schooling_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/documents_form.dart';

// Exemplo simplificado da lógica de submissão
class AdminEnrollmentScreen extends StatefulWidget {
  const AdminEnrollmentScreen({super.key});

  @override
  State<AdminEnrollmentScreen> createState() => _AdminEnrollmentScreenState();
}

class _AdminEnrollmentScreenState extends State<AdminEnrollmentScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Controladores para os outros campos do formulário (nome, cpf, etc.)

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitAdminEnrollment() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final enrollmentProvider = Provider.of<EnrollmentProvider>(
      context,
      listen: false,
    );

    try {
      // 1. Criar a conta do novo aluno no Supabase Auth
      final User? newStudentUser = await authProvider.createStudentUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName:
            enrollmentProvider
                .personalData
                .nomeCompleto, // Exemplo: usar o nome do formulário
      );

      if (newStudentUser == null) {
        // Tratar erro: não foi possível criar o usuário aluno
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro: Não foi possível criar a conta do aluno.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final String newStudentUserId = newStudentUser.id;
      print('Novo aluno criado com ID: $newStudentUserId');

      // 2. Associar e Salvar os Dados da Matrícula ao ID do Novo Aluno
      // Certifique-se de que seus modelos PersonalDataModel, AddressModel, etc.,
      // tenham o campo 'userId' e que o copyWith o atualize.
      // O EnrollmentProvider já aceita 'targetUserId'.

      // Atualiza os modelos com o userId do novo aluno
      enrollmentProvider.updatePersonalData(
        enrollmentProvider.personalData.copyWith(userId: newStudentUserId),
      );
      enrollmentProvider.updateAddressData(
        enrollmentProvider.addressData.copyWith(userId: newStudentUserId),
      );
      enrollmentProvider.updateSchoolingData(
        enrollmentProvider.schoolingData.copyWith(userId: newStudentUserId),
      );
      enrollmentProvider.updateDocumentsData(
        enrollmentProvider.documentsData.copyWith(userId: newStudentUserId),
      );

      // Agora, salve todos os dados usando o ID do novo aluno
      // O método submitEnrollment no EnrollmentProvider já usa o userId passado
      await enrollmentProvider.submitEnrollment(targetUserId: newStudentUserId);
      await enrollmentProvider.savePersonalData(targetUserId: newStudentUserId);
      await enrollmentProvider.saveAddressData(targetUserId: newStudentUserId);
      await enrollmentProvider.saveSchoolingData(
        targetUserId: newStudentUserId,
      );
      await enrollmentProvider.saveDocumentsData(
        targetUserId: newStudentUserId,
      );

      print('Dados da matrícula do aluno salvos com sucesso!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aluno cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      // Opcional: Navegar para outra tela ou limpar formulário
    } catch (e) {
      print('Erro ao cadastrar aluno: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar aluno: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha Temporária do Aluno',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Reutilize seus widgets de formulário existentes
            PersonalDataForm(),
            const SizedBox(height: 20),
            AddressForm(),
            const SizedBox(height: 20),
            SchoolingForm(),
            const SizedBox(height: 20),
            DocumentsForm(),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _submitAdminEnrollment,
              child: const Text('Cadastrar Aluno'),
            ),
          ],
        ),
      ),
    );
  }
}
