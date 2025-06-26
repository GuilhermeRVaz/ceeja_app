// COPIE E COLE TUDO ABAIXO NO ARQUIVO:
// lib/features/enrollment/presentation/screens/enrollment_stepper_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ceeja_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/providers/enrollment_provider.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/documents_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/personal_data_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/address_form.dart';
import 'package:ceeja_app/features/enrollment/presentation/widgets/schooling_form.dart';

class EnrollmentStepperScreen extends ConsumerStatefulWidget {
  const EnrollmentStepperScreen({super.key});

  @override
  ConsumerState<EnrollmentStepperScreen> createState() =>
      _EnrollmentStepperScreenState();
}

class _EnrollmentStepperScreenState
    extends ConsumerState<EnrollmentStepperScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final enrollmentState = ref.watch(enrollmentProvider);
    final enrollmentNotifier = ref.read(enrollmentProvider.notifier);

    // Lista de passos do Stepper
    final steps = [
      Step(
        title: const Text('Documentos'),
        content: const DocumentsForm(),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Dados Pessoais'),
        content: const PersonalDataForm(),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Endereço'),
        content: const AddressForm(),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Escolaridade'),
        content: const SchoolingForm(),
        isActive: _currentStep >= 3,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Requerimento de Matrícula')),
      body:
          enrollmentState.isLoading
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Processando..."),
                  ],
                ),
              )
              : Stepper(
                type: StepperType.vertical,
                currentStep: _currentStep,
                onStepTapped: (step) => setState(() => _currentStep = step),
                onStepContinue: () {
                  final isLastStep = _currentStep == steps.length - 1;

                  if (_currentStep == 0) {
                    // Lógica do botão "PRÓXIMO" no passo 1 (Documentos)
                    // Chama a função para iniciar a extração de dados
                    enrollmentNotifier.uploadAndExtractData();
                  }

                  if (isLastStep) {
                    // Lógica do botão "ENVIAR" no último passo
                    enrollmentNotifier
                        .submitEnrollment()
                        .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Matrícula enviada com sucesso!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // Navegar para uma tela de sucesso
                        })
                        .catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Erro ao enviar: $error"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        });
                  } else {
                    setState(() => _currentStep += 1);
                  }
                },
                onStepCancel:
                    _currentStep > 0
                        ? () => setState(() => _currentStep -= 1)
                        : null,
                steps: steps,
                controlsBuilder: (context, details) {
                  final isLastStep = details.stepIndex == steps.length - 1;
                  final isFirstStep = details.stepIndex == 0;
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(
                            isLastStep
                                ? 'ENVIAR MATRÍCULA'
                                : (isFirstStep
                                    ? 'PROCESSAR DOCUMENTOS'
                                    : 'PRÓXIMO'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('ANTERIOR'),
                          ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
