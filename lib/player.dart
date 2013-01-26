library player;

import 'dart:html';
import 'package:quest/image_list.dart';
import 'package:quest/assets.dart';
import 'package:quest/page.dart';
import 'package:quest/game_events.dart';

class Player implements KeyboardListener {

  ImageList _upImages;
  ImageList _downImages;
  ImageList _leftImages;
  ImageList _rightImages;

  int _x = 0;
  int _y = 0;

  int _moveX = 0;
  int _moveY = 0;
  int _speed = 1;

  int _direction;

  Map<int, bool> _keysPressed;

  Player(this._direction, this._speed,
      this._upImages, this._downImages, this._leftImages, this._rightImages) {

    this._keysPressed = new Map<int, bool>();


  }

  int get x => this._x;
  int get y => this._y;

  int get moveX => this._moveX;
  int get moveY => this._moveY;

  int get speed => this._speed;

  int get direction => this._direction;

  void setPosition(x, y) {
    this._x = x;
    this._y = y;
  }

  Image getDrawImage() {
    if (this._direction == 0) { // UP
      return this._upImages.getImage();
    } else if (this._direction == 1) { // RIGHT
      return this._rightImages.getImage();
    } else if (this._direction == 2) { // DOWN
      return this._downImages.getImage();
    } else { // LEFT
      return this._leftImages.getImage();
    }
  }

  void draw(CanvasDrawer d) {
    if (this._direction == 0) { // UP
      d.drawImage(this._upImages.getImage(), this._x, this._y, 64, 64);
    } else if (this._direction == 1) { // RIGHT
      d.drawImage(this._rightImages.getImage(), this._x, this._y, 64, 64);
    } else if (this._direction == 2) { // DOWN
      d.drawImage(this._downImages.getImage(), this._x, this._y, 64, 64);
    } else { // LEFT
      d.drawImage(this._leftImages.getImage(), this._x, this._y, 64, 64);
    }
  }

  void tick() {

    if (this._moveX != 0 || this._moveY != 0) {
      if (this._direction == 0) { // UP
        this._upImages.tick();
      } else if (this._direction == 2) { // DOWN
        this._downImages.tick();
      } else if (this._direction == 1) { // RIGHT
        this._rightImages.tick();
      } else if (this._direction == 3) { // LEFT
        this._leftImages.tick();
      }

      this._x += this._moveX * this._speed;
      this._y += this._moveY * this._speed;
    }
  }

  void moveUp() {
    this._direction = 0;
    this._moveY = -1;
  }

  void moveDown() {
    this._direction = 2;
    this._moveY = 1;
  }

  void moveRight() {
    this._direction = 1;
    this._moveX = 1;
  }

  void moveLeft() {
    this._direction = 3;
    this._moveX = -1;
  }

  void _doEvents() {

    if (this._keysPressed[38] == true) { // up
      this.moveUp();
    } else if (this._keysPressed[40] == true) { // down
      this.moveDown();
    } else {
      this._moveY = 0;
      this._upImages.reset();
      this._downImages.reset();
    }

    if (this._keysPressed[37] == true) { // left
      this.moveLeft();
    } else if (this._keysPressed[39] == true) { // right
      this.moveRight();
    } else {
      this._moveX = 0;
      this._leftImages.reset();
      this._rightImages.reset();
    }
  }



  void onKeyPress(KeyboardEvent e) {
    this._keysPressed[e.keyCode] = true;
    this._doEvents();
  }
  void onKeyUp(KeyboardEvent e) {
    this._keysPressed[e.keyCode] = false;
    this._doEvents();
  }
  void onKeyDown(KeyboardEvent e) {
    this._keysPressed[e.keyCode] = true;
    this._doEvents();
  }
}
