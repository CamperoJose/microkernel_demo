import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'base_plugin.dart';

/// Plugin que proporciona características completas (UI, flujos de usuario)
abstract class FeaturePlugin extends BasePlugin {
  /// Rutas que este plugin registra
  List<RouteBase> get routes => [];

  /// Icono para navegación (si aplica)
  IconData? get icon => null;

  /// Etiqueta para navegación (si aplica)
  String? get label => null;
}
