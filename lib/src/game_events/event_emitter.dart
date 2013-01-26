part of game_events;

abstract class EventEmitter<T> {

  Map<String, List<EventListener>> _listeners = null;

  EventEmitter() {
    this._listeners = new Map<String, List<EventListener>>();
  }

  void on(String event, EventListener l) {
    if (this._listeners[event] == null) {
      this._listeners[event] = new List<EventListener>();
    }
    this._listeners[event].add(l);
  }

  void emit(String event) {
    if (this._listeners[event] != null) {
      for (EventListener l in this._listeners[event]) {

      }
    }
  }

  void _callListener(T data);
}