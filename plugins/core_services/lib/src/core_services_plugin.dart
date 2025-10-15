import 'package:microkernel_core/microkernel_core.dart';
import 'package:core_models/core_models.dart';
import 'http_client_impl.dart';
import 'storage_service_impl.dart';

/// Plugin de servicios core que proporciona HTTP y Storage
class CoreServicesPlugin extends ServicePlugin {
  @override
  String get id => 'core_services';

  @override
  String get name => 'Core Services Plugin';

  @override
  String get version => '1.0.0';

  @override
  List<String> get dependencies => [];

  @override
  Map<Type, dynamic> get services => {
    IHttpClient: HttpClientImpl(),
    IStorageService: StorageServiceImpl(),
  };
  @override
  Future<void> onInitialize() async {
    final serviceLocator = ServiceLocator();

    // Registrar todos los servicios
    services.forEach((type, implementation) {
      serviceLocator.registerSingleton(implementation, type: type);
    });
  }

  @override
  Future<void> onDispose() async {
    // Liberar recursos si es necesario
  }
}
