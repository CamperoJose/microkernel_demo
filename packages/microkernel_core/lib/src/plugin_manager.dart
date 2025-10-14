import 'package:flutter/widgets.dart';
import 'core_plugin.dart';

class PluginManager {
  static final PluginManager _instance = PluginManager._internal();
  factory PluginManager() => _instance;
  PluginManager._internal();

  final Map<String, CorePlugin> _plugins = {};

  // Routes provided by plugins
  final Map<String, WidgetBuilder> _routes = {};

  Map<String, WidgetBuilder> get routes => Map.unmodifiable(_routes);

  Future<void> registerPlugin(CorePlugin plugin) async {
    _plugins[plugin.id] = plugin;
    await plugin.onInitialize();
  }

  T? getPlugin<T extends CorePlugin>(String id) {
    return _plugins[id] as T?;
  }

  void registerRoute(String path, WidgetBuilder builder) {
    _routes[path] = builder;
  }

  Future<void> dispose() async {
    for (final plugin in _plugins.values) {
      await plugin.onDispose();
    }
    _plugins.clear();
    _routes.clear();
  }
}
