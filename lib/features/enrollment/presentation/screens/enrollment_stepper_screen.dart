import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart'; // Importar AuthProvider
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/address_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/documents_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/personal_data_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/schooling_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnrollmentStepperScreen extends StatefulWidget {
  const EnrollmentStepperScreen({super.key});

  @override
  State<EnrollmentStepperScreen> createState() =>
      _EnrollmentStepperScreenState();
}

class _EnrollmentStepperScreenState extends State<EnrollmentStepperScreen> {
  int _currentStep = 0;
  final TextEditingController _targetUserIdController = TextEditingController();
  String? _selectedTargetUserId; // Para armazenar o ID do usuário alvo

  @override
  Widget build(BuildContext context) {
    final authProvider =
        context
            .watch<
              AuthProvider
            >(); // Usar watch para rebuildar quando a role mudar
    final String? currentUserRole = authProvider.userRole;
    final String? currentUserId = authProvider.currentUser?.id;

    // Determina o offset para os índices dos passos
    final int stepOffset = currentUserRole == 'super_usuario' ? 1 : 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/LOGOTIPO_CEEJA.png', height: 46),
            const SizedBox(width: 10),
            const Text('Requerimento de Matrícula'),
          ],
        ),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () async {
          final provider = context.read<EnrollmentProvider>();
          bool shouldContinue = false;

          // Determina o userId a ser usado para salvar os dados
          // Se for super_usuario e um targetUserId foi inserido, usa o targetUserId.
          // Caso contrário, usa o ID do usuário logado.
          final String? userIdToSave =
              (currentUserRole == 'super_usuario' &&
                      _selectedTargetUserId != null &&
                      _selectedTargetUserId!.isNotEmpty)
                  ? _selectedTargetUserId
                  : currentUserId;

          if (userIdToSave == null) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Erro: ID do usuário para salvar não encontrado.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return; // Impede a continuação se o userIdToSave for nulo
          }

          switch (_currentStep - stepOffset) {
            // Ajusta o índice do passo
            case 0: // Dados Pessoais (ou Selecionar Usuário se for super_usuario)
              if (currentUserRole == 'super_usuario' && _currentStep == 0) {
                // Se for o passo de seleção de usuário para super_usuario, apenas continua
                shouldContinue = true;
              } else {
                await provider.savePersonalData(targetUserId: userIdToSave);
                shouldContinue = true;
              }
              break;
            case 1: // Endereço (ou Dados Pessoais se for super_usuario)
              await provider.saveAddressData(targetUserId: userIdToSave);
              shouldContinue = true;
              break;
            case 2: // Escolaridade (ou Endereço se for super_usuario)
              await provider.saveSchoolingData(targetUserId: userIdToSave);
              shouldContinue = true;
              break;
            case 3: // Documentos (ou Escolaridade se for super_usuario)
              await provider.saveDocumentsData(
                targetUserId: userIdToSave,
              ); // Salva os dados dos documentos
              // Lógica de finalização (Documentos e envio final)
              // Exibe um diálogo de confirmação antes de enviar
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Confirmar Envio'),
                      content: const Text(
                        'Deseja enviar seu requerimento de matrícula? Os dados serão salvos para análise.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () async {
                            await provider.submitEnrollment(
                              targetUserId: userIdToSave,
                            );

                            // TODO: Navegar para tela de sucesso
                            if (context.mounted) {
                              Navigator.of(context).pop(); // Fecha o diálogo
                              Navigator.of(context).pop(); // Volta para a home
                            }
                          },
                          child: const Text('Enviar'),
                        ),
                      ],
                    ),
              );
              break;
          }

          if (shouldContinue) {
            setState(() {
              _currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          // Adiciona o campo de seleção de usuário se for super_usuario
          if (currentUserRole == 'super_usuario')
            Step(
              title: const Text('Selecionar Usuário'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Insira o ID do usuário para o qual você deseja preencher a matrícula:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _targetUserIdController,
                    decoration: const InputDecoration(
                      labelText: 'ID do Usuário Alvo',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedTargetUserId = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ID do Usuário Atual: ${currentUserId ?? 'Não autenticado'}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
          Step(
            title: const Text('Dados Pessoais'),
            content: const PersonalDataForm(),
            isActive: _currentStep >= (0 + stepOffset),
            state:
                _currentStep > (0 + stepOffset)
                    ? StepState.complete
                    : StepState.indexed,
          ),
          Step(
            title: const Text('Endereço'),
            content: const AddressForm(),
            isActive: _currentStep >= (1 + stepOffset),
            state:
                _currentStep > (1 + stepOffset)
                    ? StepState.complete
                    : StepState.indexed,
          ),
          Step(
            title: const Text('Escolaridade'),
            content: const SchoolingForm(),
            isActive: _currentStep >= (2 + stepOffset),
            state:
                _currentStep > (2 + stepOffset)
                    ? StepState.complete
                    : StepState.indexed,
          ),
          Step(
            title: const Text('Documentos'),
            content: const DocumentsForm(),
            isActive: _currentStep >= (3 + stepOffset),
            state:
                _currentStep > (3 + stepOffset)
                    ? StepState.complete
                    : StepState.indexed,
          ),
        ],
      ),
    );
  }
}
