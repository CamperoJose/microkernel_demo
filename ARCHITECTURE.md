# Microkernel Demo - Arquitectura Mejorada

## 📋 Resumen de Cambios

Se ha reestructurado el proyecto siguiendo las mejores prácticas de arquitectura microkernel descritas en la especificación `flutter_microkernel_spec.md`.

## 🏗️ Estructura del Proyecto

```
microkernel_demo/
├── lib/
│   └── main.dart                    # Punto de entrada de la aplicación
├── packages/
│   ├── microkernel_core/            # Sistema core del microkernel
│   │   ├── src/
│   │   │   ├── core_plugin.dart     # Interfaz base de plugins
│   │   │   ├── base_plugin.dart     # Implementación base
│   │   │   ├── feature_plugin.dart  # Plugin con UI
│   │   │   ├── service_plugin.dart  # Plugin de servicios
│   │   │   ├── plugin_registry.dart # Gestor de plugins
│   │   │   ├── event_bus.dart       # Comunicación entre plugins
│   │   │   └── service_locator.dart # Inyección de dependencias
│   │   └── pubspec.yaml
│   └── core_models/                 # Modelos y contratos compartidos
│       ├── src/
│       │   ├── contracts/           # Interfaces (IHttpClient, IAuthService, etc.)
│       │   ├── events/              # Eventos (LoginSuccessEvent, etc.)
│       │   └── models/              # Modelos de datos
│       └── pubspec.yaml
├── plugins/
│   ├── core_services/               # Plugin de servicios básicos
│   │   ├── src/
│   │   │   ├── core_services_plugin.dart
│   │   │   ├── http_client_impl.dart      # Implementación de HTTP
│   │   │   └── storage_service_impl.dart  # Implementación de Storage
│   │   └── pubspec.yaml
│   ├── auth/                        # Plugin de autenticación
│   │   ├── auth_plugin.dart
│   │   ├── auth_service_impl.dart   # Implementación de IAuthService
│   │   └── login_page.dart          # UI de login
│   └── balance/                     # Plugin de balance (NUEVO)
│       ├── src/
│       │   ├── balance_plugin.dart
│       │   ├── balance_service.dart # Servicio para obtener balance
│       │   └── balance_page.dart    # UI de balance y transacciones
│       └── pubspec.yaml
├── melos.yaml                       # Configuración del workspace
└── pubspec.yaml                     # Dependencias raíz
```

## 🔧 Componentes Implementados

### 1. **Microkernel Core** (`packages/microkernel_core`)

- **EventBus**: Sistema de eventos pub/sub para comunicación desacoplada entre plugins
- **ServiceLocator**: Contenedor de inyección de dependencias
- **PluginRegistry**: Gestor de ciclo de vida de plugins con:
  - Detección de dependencias circulares
  - Validación de dependencias
  - Inicialización en orden topológico
- **BasePlugin/FeaturePlugin/ServicePlugin**: Jerarquía de plugins

### 2. **Core Models** (`packages/core_models`)

**Contratos:**
- `IHttpClient`: Cliente HTTP abstracto
- `IStorageService`: Servicio de almacenamiento seguro
- `IAuthService`: Servicio de autenticación

**Eventos:**
- `LoginSuccessEvent`: Emitido al hacer login exitoso
- `LogoutEvent`: Emitido al cerrar sesión

**Modelos:**
- `User`: Modelo de usuario
- `LoginResponse`: Respuesta del login
- `BalanceResponse`: Respuesta de balance con transacciones
- `Transaction`: Modelo de transacción

### 3. **Core Services Plugin** (`plugins/core_services`)

**ServicePlugin** que proporciona:
- `HttpClientImpl`: Cliente HTTP basado en `package:http`
- `StorageServiceImpl`: Storage basado en `flutter_secure_storage`

**Dependencias:** Ninguna (es el plugin base)

### 4. **Auth Plugin** (`plugins/auth`)

**FeaturePlugin** que proporciona:
- Ruta `/auth/login` con UI de login
- `AuthServiceImpl`: Implementación de autenticación
- Emisión de `LoginSuccessEvent` al login exitoso
- Almacenamiento seguro del token JWT

**Dependencias:** `core_services`

### 5. **Balance Plugin** (`plugins/balance`) ⭐ NUEVO

**FeaturePlugin** que proporciona:
- Ruta `/balance` con UI de balance y transacciones
- `BalanceService`: Consume endpoint `/balance` con token Bearer
- Escucha `LoginSuccessEvent` para pre-cargar datos
- Muestra:
  - Número de cuenta
  - Balance disponible
  - Últimas 5 transacciones

**Dependencias:** `core_services`, `auth`

**API Consumida:**
```bash
GET http://localhost:3000/api/v7/pocketbank/balance
Authorization: Bearer <token>
```

## 🔄 Flujo de la Aplicación

1. **Inicio** → Usuario ve pantalla de login (`/auth/login`)
2. **Login Exitoso** → 
   - Se guarda el token en storage seguro
   - Se emite `LoginSuccessEvent`
   - Se navega automáticamente a `/balance`
3. **Balance** → 
   - Se consulta el endpoint con el token
   - Se muestra balance y transacciones
   - Usuario puede hacer logout

## 📦 Gestión de Dependencias

### Workspace Configuration

El proyecto usa **Pub Workspaces** para gestionar dependencias locales:

```yaml
# pubspec.yaml (raíz)
resolution: workspace

workspace:
  - packages/microkernel_core
  - packages/core_models
  - plugins/auth
  - plugins/core_services
  - plugins/balance
```

### Melos Configuration

```yaml
# melos.yaml
packages:
  - "packages/**"
  - "plugins/**"

scripts:
  analyze: melos exec -- flutter analyze
  get: melos exec -- flutter pub get
  clean: melos exec -- flutter clean
```

## 🚀 Comandos Útiles

```bash
# Bootstrap del workspace (primera vez)
melos bootstrap

# Obtener dependencias
flutter pub get

# Analizar código
dart analyze

# Limpiar
melos clean

# Formatear código
melos format

# Ejecutar aplicación
flutter run
```

## 🎯 Mejores Prácticas Aplicadas

✅ **Separación de Responsabilidades**: Cada plugin tiene una responsabilidad clara
✅ **Dependency Inversion**: Uso de interfaces (contratos) en lugar de implementaciones concretas
✅ **Event-Driven Architecture**: Comunicación desacoplada vía EventBus
✅ **Service Locator Pattern**: Gestión centralizada de dependencias
✅ **Plugin Architecture**: Sistema extensible y modular
✅ **Lazy Loading**: Plugins se cargan solo cuando se necesitan
✅ **Type-Safe Routing**: Uso de go_router con rutas tipadas
✅ **Secure Storage**: Tokens almacenados con flutter_secure_storage

## 🔐 Seguridad

- Los tokens JWT se almacenan en `flutter_secure_storage`
- Las contraseñas nunca se almacenan localmente
- El token se envía en el header `Authorization: Bearer <token>`

## 📝 Próximos Pasos Sugeridos

1. **Tests Unitarios**: Agregar tests para cada plugin
2. **Tests de Integración**: Validar flujos completos
3. **Manejo de Errores**: Mejorar feedback de errores
4. **Offline Support**: Cachear datos cuando no hay conexión
5. **Refresh Token**: Implementar renovación automática de tokens
6. **Plugin de Transferencias**: Crear nuevo plugin para realizar transferencias

## 🐛 Debugging

Si encuentras errores:

```bash
# Limpiar y regenerar dependencias
flutter clean
flutter pub get
dart analyze
```

## 📚 Documentación de Referencia

- [Especificación Microkernel](flutter_microkernel_spec.md)
- [go_router Documentation](https://pub.dev/packages/go_router)
- [Melos Documentation](https://melos.invertase.dev)

---

**Versión**: 2.0  
**Fecha**: Octubre 2025  
**Autor**: Equipo de Desarrollo
