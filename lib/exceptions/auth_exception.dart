class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'O email ja existe',
    'OPERATION_NOT_ALLOWED': 'Esta operacao nao e permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Tente mais tarde',
    'EMAIL_NOT_FOUND': 'E-mail nao encontrado',
    'INVALID_PASSWORD': 'Senha invalida',
    'USER_DISABLED': 'Usuario desativado'
  };
  
  final String key;

  AuthException(this.key);

  @override
  toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    }
    return 'Ocorreu um erro ao tentar autenticar este usuario';
  }
}