library game_object;

import 'package:quest/assets.dart';
import 'package:quest/game_interface.dart';

part 'game_object_manager.dart';

abstract class GameObject implements Tickable {

  int _x;
  int _y;
  int _width;
  int _height;

  // Does it block movement?
  bool _blocking;

  Image _img;

  GameObject(this._img, this._x, this._y, this._width, this._height, this._blocking);

  int get x => this._x;
  int get y => this._y;
  int get width => this._width;
  int get height => this._height;
  Image get image => this._img;
  bool get blocking => this._blocking;
}
