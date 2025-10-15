/// Contrato base para plugins del microkernel
/// Todos los plugins deben implementar esta interfaz
abstract class CorePlugin {
  /// Identificador único del plugin
  String get id;

  /// Nombre descriptivo del plugin
  String get name;

  /// Versión del plugin
  String get version;

  /// Lista de IDs de plugins de los que depende este plugin
  List<String> get dependencies => [];

  /// Inicializa el plugin
  /// Se llama cuando el plugin es registrado
  Future<void> initialize();

  /// Libera recursos del plugin
  /// Se llama cuando la aplicación se cierra o el plugin se desactiva
  Future<void> dispose();

  /// Indica si el plugin está inicializado
  bool get isInitialized;

  /// Método protegido para que las subclases implementen la lógica de inicialización
  Future<void> onInitialize();

  /// Método protegido para que las subclases implementen la lógica de limpieza
  Future<void> onDispose();
}
