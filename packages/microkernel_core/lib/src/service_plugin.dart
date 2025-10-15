import 'base_plugin.dart';

/// Plugin que proporciona servicios (sin UI)
abstract class ServicePlugin extends BasePlugin {
  /// Servicios que este plugin proporciona
  Map<Type, dynamic> get services => {};
}
