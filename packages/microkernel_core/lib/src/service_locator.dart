/// Service Locator para gestión de dependencias
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};
  final Map<Type, dynamic Function()> _factories = {};

  /// Registra un singleton
  void registerSingleton<T>(T instance, {Type? type}) {
    final key = type ?? T;
    if (_services.containsKey(key)) {
      throw StateError('Servicio $key ya está registrado');
    }
    _services[key] = instance;
  }

  /// Registra una factory
  void register<T>(T Function() factory, {Type? type}) {
    final key = type ?? T;
    if (_factories.containsKey(key)) {
      throw StateError('Factory $key ya está registrada');
    }
    _factories[key] = factory;
  }

  /// Obtiene un servicio
  T get<T>() {
    // Buscar singleton
    if (_services.containsKey(T)) {
      return _services[T] as T;
    }

    // Buscar factory
    if (_factories.containsKey(T)) {
      return _factories[T]!() as T;
    }

    throw StateError('Servicio $T no está registrado');
  }

  /// Verifica si un servicio está registrado
  bool has<T>() {
    return _services.containsKey(T) || _factories.containsKey(T);
  }

  /// Limpia todos los servicios
  void reset() {
    _services.clear();
    _factories.clear();
  }
}
