part of game_events;

abstract class GameEvent<T> {

  T _data;
  EventEmitter _emitter;

  //factory GameEvent.fromEmitter(EventEmitter emitter, T data);
}
