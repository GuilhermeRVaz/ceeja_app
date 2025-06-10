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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/LOGOTIPO_CEEJA.png', height: 40),
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
          final isLastStep = _currentStep == 3;
          if (isLastStep) {
            // Lógica de finalização
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
                          final provider = context.read<EnrollmentProvider>();
                          await provider.submitEnrollment();

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
          } else {
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
          Step(
            title: const Text('Dados Pessoais'),
            content: const PersonalDataForm(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Endereço'),
            content: const AddressForm(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Escolaridade'),
            content: const SchoolingForm(),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Documentos'),
            content: const DocumentsForm(),
            isActive: _currentStep >= 3,
            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }
}
