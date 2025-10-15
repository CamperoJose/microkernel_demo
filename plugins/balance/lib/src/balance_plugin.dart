import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:microkernel_core/microkernel_core.dart';
import 'package:core_models/core_models.dart';

import 'balance_page.dart';
import 'balance_service.dart';

/// Plugin de balance que muestra el saldo y últimas transacciones
class BalancePlugin extends FeaturePlugin {
  @override
  String get id => 'balance';

  @override
  String get name => 'Balance Plugin';

  @override
  String get version => '1.0.0';

  @override
  List<String> get dependencies => ['core_services', 'auth'];

  @override
  IconData get icon => Icons.account_balance_wallet;

  @override
  String get label => 'Balance';

  @override
  List<RouteBase> get routes => [
    GoRoute(
      path: '/balance',
      name: 'balance',
      builder: (context, state) => const BalancePage(),
    ),
  ];

  @override
  Future<void> onInitialize() async {
    final serviceLocator = ServiceLocator();

    // Obtener dependencias
    final httpClient = serviceLocator.get<IHttpClient>();
    final authService = serviceLocator.get<IAuthService>();

    // Registrar servicio de balance
    final balanceService = BalanceService(httpClient, authService);
    serviceLocator.registerSingleton<BalanceService>(balanceService);

    // Escuchar eventos de login
    EventBus().on<LoginSuccessEvent>().listen((event) {
      // Podríamos pre-cargar datos aquí si fuera necesario
    });
  }

  @override
  Future<void> onDispose() async {
    // Cleanup
  }
}
