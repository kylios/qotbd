library page;

import 'dart:html';


import 'package:quest/tile.dart';

part 'src/canvas/canvas_manager.dart';
part 'src/canvas/canvas_drawer.dart';
part 'src/events/event.dart';
part 'src/events/event_handler.dart';


class Page {

  CanvasManager _manager;
  CanvasDrawer _drawer;

  Page() {

    this._manager = new CanvasManager(query('canvas'), width: 640, height: 480);
    this._drawer = new CanvasDrawer(this._manager._c);
  }

  CanvasManager get canvasManager => this._manager;
  CanvasDrawer get canvasDrawer => this._drawer;



}