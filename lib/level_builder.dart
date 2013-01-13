library level_builder;

import 'dart:html';
import 'package:quest/page.dart';
import 'package:quest/viewport.dart';
import 'package:quest/assets.dart';
import 'package:quest/level.dart';
import 'package:quest/tile.dart';
import 'package:quest/game_object.dart';


class LevelBuilder extends MouseListener {

  Page _page;
  Viewport _viewport;
  AssetManager _imageList;

  Image _currentImage = null;
  bool _drawing = false;
  bool _moving = false;
  bool _placeTiles = true;
  bool _placeObjects = false;
  bool _blocking = true;

  bool _erase = false;
  bool _showImageOnCanvas = false;
  int _imageX = 0;
  int _imageY = 0;

  List<String> _colors = [ "white", "red", "orange", "yellow", "green", "blue", "purple", "black" ];
  int _colorIdx = 0;

  EditableRegion _region = null;

  LevelBuilder(this._page, this._imageList) {
  }

  Image get currentImage => this._currentImage;
  set currentImage(Image i) {
    this._currentImage = i;
    this._erase = false;
  }

  bool get placeTiles => this._placeTiles;
  bool get placeObjects => this._placeObjects;
  set placeTiles(bool p) => this._placeTiles = p;
  set placeObjects(bool p) => this._placeObjects = p;

  bool get blocking => this._blocking;
  set blocking(bool b) => this._blocking = b;

  void start(String levelName, String regionName, int width, int height) {

    this._region = new EditableRegion(levelName, regionName, this._imageList);
    this._page.canvasManager.addMouseListener(this);
    this._viewport = new Viewport(this._page.canvasDrawer,
        640, 480, 64 * width, 64 * height, false);

    this.draw();
    this._page.canvasManager.show();
    // new level
    this._region.start(width, height);
  }

  void erase() {
    this._currentImage = null;
    this._erase = true;
  }

  String _currentImgKey = null;
  void onMouseOver(MouseEvent e) {
    this._showImageOnCanvas = true;
  }
  void onMouseOut(MouseEvent e) {
    this._showImageOnCanvas = false;
    this._moving = false;
  }
  void onMouseMove(MouseEvent e) {

    int cursorX = e.clientX - this._page.canvasManager.offsetX;
    int cursorY = e.clientY - this._page.canvasManager.offsetY;

    if (this._placeTiles) {

      this._imageX = ((cursorX + this._viewport.xOffset) ~/ 64) * 64 + this._viewport.xOffset % 64;
      this._imageY = ((cursorY + this._viewport.yOffset) ~/ 64) * 64 + this._viewport.yOffset % 64;

    } else if (this._placeObjects) {

      this._imageX = ((cursorX + this._viewport.xOffset) ~/ 16) * 16 + this._viewport.xOffset % 64;
      this._imageY = ((cursorY + this._viewport.yOffset) ~/ 16) * 16 + this._viewport.yOffset % 64;
    }

    if (cursorX <= 64 &&
        this._viewport.viewWidth < this._viewport.xBounds) {

      this._viewport.setOffset(this._viewport.xOffset - 16, this._viewport.yOffset);
    } else if (cursorX >= this._viewport.viewWidth - 64 &&
        this._viewport.viewWidth < this._viewport.xBounds) {

      this._viewport.setOffset(this._viewport.xOffset + 16, this._viewport.yOffset);
    }
    if (cursorY <= 64 &&
        this._viewport.viewHeight < this._viewport.yBounds) {

      this._viewport.setOffset(this._viewport.xOffset, this._viewport.yOffset - 16);
    } else if (cursorY >= this._viewport.viewHeight - 64 &&
        this._viewport.viewHeight < this._viewport.yBounds) {

      this._viewport.setOffset(this._viewport.xOffset, this._viewport.yOffset + 16);
    }

    this.draw();
  }
  void onMouseClick(MouseEvent e) {
    int offsetX = this._viewport.xOffset;
    int offsetY = this._viewport.yOffset;

    int cursorX = e.clientX - this._page.canvasManager.offsetX;
    int cursorY = e.clientY - this._page.canvasManager.offsetY;

    int x = cursorX + offsetX;
    int y = cursorY + offsetY;
    if (this._placeTiles) {

      int row = y ~/ 64;
      int col = x ~/ 64;

      if (this._erase){
        this._region.clearTile(row, col);
      }
      else if (this._currentImage != null) {
        this._region.setTile(row, col, this._currentImage.imgKey);
      }
    }
    if (this._placeObjects) {
      int row = y ~/ 16;
      int col = x ~/ 16;

      if (this._erase){
        this._region.removeObject(row, col);
      } else if (this._currentImage != null) {
        GenericObject o = new GenericObject(this._currentImage, col * 16, row * 16, 64, 64, this._blocking);
        this._region.addObject(o);
      }
    }
  }


  void draw() {

    CanvasDrawer d = this._page.canvasDrawer;
    d.clear(this._page.canvasManager);

    int row = 0;
    int col = 0;
    for (List<String> levelRow in this._region.tiles) {
      col = 0;
      for (String imgKey in levelRow) {
        if (imgKey != null) {
          Tile t = new Tile(this._imageList.getImage(imgKey));
          this._viewport.drawImage(t.image, 64 * col, 64 * row, 64, 64);
        }
        col++;
      }
      row++;
    }

    for (GameObject o in this._region.staticObjects) {
      this._viewport.drawImage(o.image, o.x, o.y, 64, 64);
    }

    int i;
    for (i = 0; i < this._region.rows; i++) {
      this._viewport.drawLine(0,  i * 64,       this._region.width, i * 64);
      this._viewport.drawLine(0,  i * 64 + 16,  this._region.width, i * 64 + 16, CanvasDrawer.DASHED);
      this._viewport.drawLine(0,  i * 64 + 32,  this._region.width, i * 64 + 32, CanvasDrawer.DASHED);
      this._viewport.drawLine(0,  i * 64 + 48,  this._region.width, i * 64 + 48, CanvasDrawer.DASHED);
    }
    this._viewport.drawLine(0, i * 64, this._region.width, i * 64);
    for (i = 0; i < this._region.cols; i++) {
      this._viewport.drawLine(i * 64,       0,  i * 64,       this._region.height);
      this._viewport.drawLine(i * 64 + 16,  0,  i * 64 + 16,  this._region.height, CanvasDrawer.DASHED);
      this._viewport.drawLine(i * 64 + 32,  0,  i * 64 + 32,  this._region.height, CanvasDrawer.DASHED);
      this._viewport.drawLine(i * 64 + 48,  0,  i * 64 + 48,  this._region.height, CanvasDrawer.DASHED);
    }
    this._viewport.drawLine(i * 64, 0, i * 64, this._region.height);


    if (this._currentImage != null && this._showImageOnCanvas) {
      this._viewport.drawImage(this._currentImage,
          this._imageX - this._viewport.xOffset % 64,
          this._imageY - this._viewport.yOffset % 64,
          64, 64);
    }
  }

  String export() {
    return this._region.toJson();
  }
}