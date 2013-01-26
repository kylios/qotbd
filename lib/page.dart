library page;

import 'dart:html';
import 'dart:math';

import 'package:quest/assets.dart';
import 'package:quest/game_events.dart';

part 'src/page/input_controller.dart';
part 'src/page/canvas/manager.dart';
part 'src/page/canvas/drawer.dart';




class Page {

  List<KeyboardListener> _keyboardListeners;
  List<MouseListener> _mouseListeners;


  Page() {

    this._keyboardListeners = new List<KeyboardListener>();
    this._mouseListeners = new List<MouseListener>();
  }

  void addKeyboardListener(KeyboardListener k) {
    //this._keyboardListeners.add(k);
window.console.log(k);
    window.on.keyDown.add(k.onKeyDown);
    window.on.keyUp.add(k.onKeyUp);
    window.on.keyPress.add(k.onKeyPress);

  }

  void addMouseListener(MouseListener m) {

    window.on.click.add(m.onMouseClick);
  }
}