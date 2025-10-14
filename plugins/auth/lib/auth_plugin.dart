import 'package:microkernel_core/microkernel_core.dart';

import 'login_page.dart';
import 'auth_service.dart';

class AuthPlugin extends CorePlugin {
  @override
  String get id => 'auth_plugin';

  @override
  String get name => 'Auth Plugin';

  @override
  String get version => '1.0.0';

  late final AuthService _authService;

  @override
  Future<void> onInitialize() async {
    _authService = AuthService();
    // Register route using the core PluginManager
    PluginManager().registerRoute(
      '/auth/login',
      (_) => LoginPage(authService: _authService),
    );
  }

  @override
  Future<void> onDispose() async {
    // Cleanup if necessary
  }
}
