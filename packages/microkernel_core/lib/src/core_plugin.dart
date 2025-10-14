import 'package:flutter/widgets.dart';

/// A minimal plugin contract for the microkernel.
/// Plugins should implement `id`, `name`, `version` and
/// provide async lifecycle hooks.
abstract class CorePlugin {
  /// Unique plugin id (used as key in the manager)
  String get id;

  /// Human friendly name
  String get name;

  /// Semantic version
  String get version;

  /// Called when the plugin is initialized. Plugins can register
  /// routes or services during this call.
  Future<void> onInitialize();

  /// Called when the plugin is being disposed.
  Future<void> onDispose();

  /// Optional: helper to register routes during initialization.
  /// Plugins can call [PluginManager().registerRoute(...)] directly
  /// if they prefer.
  @protected
  void registerRoute(String path, WidgetBuilder builder) {
    // No-op by default. Implementations may route through PluginManager.
  }
}
