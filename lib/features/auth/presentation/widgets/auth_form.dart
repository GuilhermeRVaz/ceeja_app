import 'package:flutter/material.dart';
import 'package:ceeja_app/core/widgets/custom_text_field.dart';
import 'package:ceeja_app/core/widgets/custom_button.dart';
import 'package:ceeja_app/core/utils/validators.dart';

class AuthForm extends StatefulWidget {
  final Future<void> Function(String email, String password, String? fullName, bool isLogin) submitFn;
  final bool isLogin;
  final bool isLoading;

  const AuthForm({
    super.key, // Correção aqui
    required this.submitFn,
    required this.isLogin,
    required this.isLoading,
  }); // Correção aqui

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController(); // Apenas para cadastro
  final _confirmPasswordController = TextEditingController(); // Apenas para cadastro

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus(); // Fecha o teclado

    if (isValid == true) {
      widget.submitFn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        widget.isLogin ? null : _fullNameController.text.trim(),
        widget.isLogin,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (!widget.isLogin)
            CustomTextField(
              controller: _fullNameController,
              labelText: 'Nome Completo',
              prefixIcon: Icons.person_outline,
              keyboardType: TextInputType.name,
              validator: (value) => Validators.validateNotEmpty(value, 'Nome completo'),
            ),
          if (!widget.isLogin) const SizedBox(height: 16),
          CustomTextField(
            controller: _emailController,
            labelText: 'E-mail',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            labelText: 'Senha',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            validator: (value) => Validators.validatePassword(value, isLogin: widget.isLogin),
          ),
          if (!widget.isLogin) const SizedBox(height: 16),
          if (!widget.isLogin)
            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirmar Senha',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'As senhas não coincidem.';
                }
                return null;
              },
            ),
          const SizedBox(height: 24),
          CustomButton(
            text: widget.isLogin ? 'Entrar' : 'Cadastrar',
            onPressed: _trySubmit,
            isLoading: widget.isLoading,
          ),
        ],
      ),
    );
  }
}

