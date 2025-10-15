import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:microkernel_core/microkernel_core.dart';
import 'package:core_models/core_models.dart';

import 'login_page.dart';
import 'auth_service_impl.dart';

/// Plugin de autenticación
class AuthPlugin extends FeaturePlugin {
  @override
  String get id => 'auth';

  @override
  String get name => 'Authentication Plugin';

  @override
  String get version => '1.0.0';

  @override
  List<String> get dependencies => ['core_services'];

  @override
  IconData get icon => Icons.lock;

  @override
  String get label => 'Autenticación';

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: '/auth/login',
      name: 'auth_login',
      builder: (context, state) => const LoginPage(),
    ),
  ];

  @override
  Future<void> onInitialize() async {
    final serviceLocator = ServiceLocator();

    // Obtener dependencias necesarias
    final httpClient = serviceLocator.get<IHttpClient>();
    final storage = serviceLocator.get<IStorageService>();

    // Registrar servicio de autenticación
    final authService = AuthServiceImpl(httpClient, storage);
    serviceLocator.registerSingleton<IAuthService>(authService);
  }

  @override
  Future<void> onDispose() async {
    // Cleanup si es necesario
  }
}
