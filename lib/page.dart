library page;

import 'dart:html';

import 'package:quest/assets.dart';

part 'src/canvas/canvas_manager.dart';
part 'src/canvas/canvas_drawer.dart';
part 'src/events/event.dart';
part 'src/events/event_handler.dart';
part 'src/events/keyboard_listener.dart';




class Page {

  CanvasManager _manager;
  CanvasDrawer _drawer;

  List<KeyboardListener> _keyboardListeners;


  Page() {

    this._manager = new CanvasManager(query('canvas'), width: 640, height: 480);
    this._drawer = new CanvasDrawer(this._manager._c);

    this._keyboardListeners = new List<KeyboardListener>();

    window.on.keyDown.add(this._onKeyDown);
    window.on.keyUp.add(this._onKeyUp);
    window.on.keyPress.add(this._onKeyPress);

    window.console.log("Page done constructing");

  }

  CanvasManager get canvasManager => this._manager;
  CanvasDrawer get canvasDrawer => this._drawer;

  void addKeyboardListener(KeyboardListener k) {
    this._keyboardListeners.add(k);
  }




  void _onKeyDown(KeyboardEvent e) {
    for (KeyboardListener l in this._keyboardListeners) {
      l.onKeyDown(e);
    }
  }
  void _onKeyUp(KeyboardEvent e) {
    for (KeyboardListener l in this._keyboardListeners) {
      l.onKeyUp(e);
    }
  }
  void _onKeyPress(KeyboardEvent e) {
    for (KeyboardListener l in this._keyboardListeners) {
      l.onKeyPress(e);
    }
  }
}