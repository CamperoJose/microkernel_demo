import 'dart:async';

/// EventBus para comunicación desacoplada entre plugins
class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final _streamController = StreamController<dynamic>.broadcast();

  /// Emite un evento
  void emit<T>(T event) {
    _streamController.add(event);
  }

  /// Escucha eventos de un tipo específico
  Stream<T> on<T>() {
    return _streamController.stream.where((event) => event is T).cast<T>();
  }

  /// Cierra el event bus
  void dispose() {
    _streamController.close();
  }
}
