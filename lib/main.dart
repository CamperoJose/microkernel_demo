import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:microkernel_core/microkernel_core.dart';

// Imports de plugins
import 'package:core_services/core_services.dart';
import 'package:auth_plugin/auth_plugin.dart';
import 'package:balance_plugin/balance_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Registrar e inicializar plugins
  await setupPlugins();

  runApp(const MyApp());
}

Future<void> setupPlugins() async {
  final registry = PluginRegistry();

  // Registrar plugins en el orden correcto (respetando dependencias)
  await registry.register(CoreServicesPlugin());
  await registry.register(AuthPlugin());
  await registry.register(BalancePlugin());

  // Inicializar todos los plugins
  await registry.initializeAll();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Microkernel Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      routerConfig: _buildRouter(),
    );
  }

  GoRouter _buildRouter() {
    final registry = PluginRegistry();
    final featurePlugins = registry.getFeaturePlugins();

    // Recolectar todas las rutas de los plugins
    final routes = <RouteBase>[];
    for (final plugin in featurePlugins) {
      routes.addAll(plugin.routes);
    }

    return GoRouter(
      initialLocation: '/auth/login',
      routes: routes,
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Ruta no encontrada: ${state.matchedLocation}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/auth/login'),
                child: const Text('Ir al login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
