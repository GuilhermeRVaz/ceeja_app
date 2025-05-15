import 'package:flutter/material.dart';
import 'package:ceeja_app/core/theme/app_theme.dart'; 

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isLoading;

  const CustomButton({
    super.key, // Correção aqui
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 50.0, // Altura padrão
    this.isLoading = false,
  }); // Correção aqui

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity, // Largura padrão é a máxima disponível
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Desabilita o botão durante o loading
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppTheme.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: AppTheme.whiteColor,
                  strokeWidth: 3,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor ?? AppTheme.whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

