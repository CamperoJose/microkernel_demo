import 'core_plugin.dart';

/// Implementación base de Plugin con gestión de estado de inicialización
abstract class BasePlugin implements CorePlugin {
  bool _isInitialized = false;

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      throw StateError('Plugin $id ya está inicializado');
    }

    await onInitialize();
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    if (!_isInitialized) {
      return;
    }

    await onDispose();
    _isInitialized = false;
  }
}
