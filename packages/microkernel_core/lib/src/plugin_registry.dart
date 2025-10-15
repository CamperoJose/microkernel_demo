import 'core_plugin.dart';
import 'feature_plugin.dart';

/// Registry que gestiona el ciclo de vida de todos los plugins
class PluginRegistry {
  static final PluginRegistry _instance = PluginRegistry._internal();
  factory PluginRegistry() => _instance;
  PluginRegistry._internal();

  final Map<String, CorePlugin> _plugins = {};
  final Map<String, bool> _pluginStatus = {};

  /// Registra un plugin
  Future<void> register(CorePlugin plugin) async {
    if (_plugins.containsKey(plugin.id)) {
      throw StateError('Plugin ${plugin.id} ya está registrado');
    }

    // Verificar dependencias circulares
    _checkCircularDependencies(plugin);

    // Verificar que todas las dependencias existan
    _checkMissingDependencies(plugin);

    _plugins[plugin.id] = plugin;
    _pluginStatus[plugin.id] = false;
  }

  /// Inicializa un plugin y sus dependencias
  Future<void> initialize(String pluginId) async {
    if (!_plugins.containsKey(pluginId)) {
      throw StateError('Plugin $pluginId no está registrado');
    }

    if (_pluginStatus[pluginId] == true) {
      return; // Ya inicializado
    }

    final plugin = _plugins[pluginId]!;

    // Inicializar dependencias primero
    for (final dependencyId in plugin.dependencies) {
      await initialize(dependencyId);
    }

    // Inicializar el plugin
    try {
      await plugin.initialize();
      _pluginStatus[pluginId] = true;
    } catch (e) {
      throw StateError('Error al inicializar plugin $pluginId: $e');
    }
  }

  /// Inicializa todos los plugins en el orden correcto
  Future<void> initializeAll() async {
    final sortedPlugins = _topologicalSort();

    for (final pluginId in sortedPlugins) {
      if (!_pluginStatus[pluginId]!) {
        await initialize(pluginId);
      }
    }
  }

  /// Obtiene un plugin por su ID
  T getPlugin<T extends CorePlugin>(String pluginId) {
    if (!_plugins.containsKey(pluginId)) {
      throw StateError('Plugin $pluginId no encontrado');
    }
    return _plugins[pluginId] as T;
  }

  /// Obtiene todos los FeaturePlugins registrados
  List<FeaturePlugin> getFeaturePlugins() {
    return _plugins.values.whereType<FeaturePlugin>().toList();
  }

  /// Verifica si un plugin está registrado
  bool hasPlugin(String pluginId) {
    return _plugins.containsKey(pluginId);
  }

  /// Limpia todos los plugins
  Future<void> disposeAll() async {
    for (final plugin in _plugins.values) {
      if (plugin.isInitialized) {
        await plugin.dispose();
      }
    }
  }

  void _checkCircularDependencies(CorePlugin plugin) {
    final visited = <String>{};
    final recursionStack = <String>{};

    bool hasCycle(String pluginId) {
      if (!visited.contains(pluginId)) {
        visited.add(pluginId);
        recursionStack.add(pluginId);

        final currentPlugin = _plugins[pluginId];
        if (currentPlugin != null) {
          for (final depId in currentPlugin.dependencies) {
            if (!visited.contains(depId) && hasCycle(depId)) {
              return true;
            } else if (recursionStack.contains(depId)) {
              return true;
            }
          }
        }
      }
      recursionStack.remove(pluginId);
      return false;
    }

    if (hasCycle(plugin.id)) {
      throw StateError(
        'Dependencia circular detectada para plugin ${plugin.id}',
      );
    }
  }

  void _checkMissingDependencies(CorePlugin plugin) {
    for (final depId in plugin.dependencies) {
      if (!_plugins.containsKey(depId)) {
        throw StateError(
          'Plugin ${plugin.id} depende de $depId que no está registrado',
        );
      }
    }
  }

  List<String> _topologicalSort() {
    final sorted = <String>[];
    final visited = <String>{};

    void visit(String pluginId) {
      if (visited.contains(pluginId)) return;
      visited.add(pluginId);

      final plugin = _plugins[pluginId];
      if (plugin != null) {
        for (final depId in plugin.dependencies) {
          visit(depId);
        }
      }

      sorted.add(pluginId);
    }

    for (final pluginId in _plugins.keys) {
      visit(pluginId);
    }

    return sorted;
  }
}
