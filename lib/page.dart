library page;

import 'dart:html';
import 'dart:math';

import 'package:quest/assets.dart';

part 'src/page/input_controller.dart';
part 'src/page/canvas/canvas_manager.dart';
part 'src/page/canvas/canvas_drawer.dart';
part 'src/game_events/event.dart';
part 'src/game_events/event_handler.dart';
part 'src/game_events/keyboard_listener.dart';
part 'src/game_events/mouse_listener.dart';




class Page {

  CanvasManager _manager;
  CanvasDrawer _drawer;

  List<KeyboardListener> _keyboardListeners;
  List<MouseListener> _mouseListeners;


  Page() {

    this._manager = new CanvasManager();

    this._keyboardListeners = new List<KeyboardListener>();

    window.on.keyDown.add(this._onKeyDown);
    window.on.keyUp.add(this._onKeyUp);
    window.on.keyPress.add(this._onKeyPress);

    window.console.log("Page done constructing");

  }

  void manageCanvas(CanvasElement canvas,
                    width,
                    height,
                    hidden) {
    this._manager.manageCanvas(canvas, width: width, height: height, hidden: hidden);
    this._drawer = new CanvasDrawer(this._manager._c);
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