import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:microkernel_core/microkernel_core.dart';
import 'package:core_models/core_models.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _loading = false;

  Future<void> _handleLogin() async {
    setState(() => _loading = true);
    final username = _userController.text.trim();
    final password = _passController.text.trim();

    try {
      final authService = ServiceLocator().get<IAuthService>();
      final response = await authService.login(username, password);

      setState(() => _loading = false);

      if (response.code == 'M-0001') {
        // Emitir evento de login exitoso
        EventBus().emit(
          LoginSuccessEvent(
            userId: response.userId,
            userName: response.user?.name ?? username,
            token: response.token,
          ),
        );

        if (!mounted) return;

        // Navegar a la pantalla de balance
        context.go('/balance');
      } else {
        if (!mounted) return;
        _showError('Código de respuesta inesperado: ${response.code}');
      }
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      _showError('Error al iniciar sesión: $e');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _handleLogin,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
