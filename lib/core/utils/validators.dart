class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu e-mail.';
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um e-mail válido.';
    }
    return null;
  }

  static String? validatePassword(String? value, {bool isLogin = false}) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha.';
    }
    if (!isLogin && value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    return null;
  }

  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'O campo $fieldName não pode estar vazio.';
    }
    return null;
  }

  // Adicione outros validadores conforme necessário
}
