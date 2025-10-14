import 'package:flutter/material.dart';
import 'package:microkernel_core/microkernel_core.dart';
import 'package:auth_plugin/auth_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final manager = PluginManager();
  await manager.registerPlugin(AuthPlugin());

  runApp(MyApp(manager: manager));
}

class MyApp extends StatelessWidget {
  final PluginManager manager;
  MyApp({super.key, PluginManager? manager})
    : manager = manager ?? PluginManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microkernel Demo',
      initialRoute: '/auth/login',
      routes: manager.routes,
    );
  }
}
