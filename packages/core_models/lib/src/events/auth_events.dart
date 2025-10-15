/// Evento base de autenticación
abstract class AuthEvent {}

/// Evento emitido cuando el login es exitoso
class LoginSuccessEvent extends AuthEvent {
  final String userId;
  final String userName;
  final String token;

  LoginSuccessEvent({
    required this.userId,
    required this.userName,
    required this.token,
  });
}

/// Evento emitido cuando se cierra sesión
class LogoutEvent extends AuthEvent {}

/// Evento emitido cuando la sesión expira
class SessionExpiredEvent extends AuthEvent {}
