library level_builder;

import 'dart:html';
import 'package:quest/page.dart';
import 'package:quest/viewport.dart';
import 'package:quest/assets.dart';
import 'package:quest/level.dart';
import 'package:quest/tile.dart';



class LevelBuilder extends MouseListener {

  Page _page;
  Viewport _viewport;
  AssetManager _imageList;

  Image _currentImage = null;
  bool _drawing = false;
  bool _moving = false;

  bool _showImageOnCanvas = false;
  int _imageX = 0;
  int _imageY = 0;

  List<String> _colors = [ "white", "red", "orange", "yellow", "green", "blue", "purple", "black" ];
  int _colorIdx = 0;

  EditableRegion _region = null;

  LevelBuilder(this._page, this._imageList) {
    this._region = new EditableRegion("level1", "test region", this._imageList);
    this._page.canvasManager.addMouseListener(this);
    this._viewport = new Viewport(this._page.canvasDrawer,
        640, 480, 64 * 20, 64 * 20, true);

    this.draw();
  }

  Image get currentImage => this._currentImage;
  set currentImage(Image i) => this._currentImage = i;

  void start(int width, int height) {
    this._page.canvasManager.show();
    // new level
    this._region.start(width, height);
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

    window.console.log("Corsor coords: (${cursorX}, ${cursorY})");

    this._imageX = (cursorX ~/ 64) * 64;
    this._imageY = (cursorY ~/ 64) * 64;

    if (cursorX <= 64) {

      this._viewport.setOffset(this._viewport.xOffset - 16, this._viewport.yOffset);
    } else if (cursorX >= this._viewport.viewWidth - 64) {

      this._viewport.setOffset(this._viewport.xOffset + 16, this._viewport.yOffset);
    }
    if (cursorY <= 64) {

      this._viewport.setOffset(this._viewport.xOffset, this._viewport.yOffset - 16);
    } else if (cursorY >= this._viewport.viewHeight - 64) {

      this._viewport.setOffset(this._viewport.xOffset, this._viewport.yOffset + 16);
    }

    this.draw();
  }
  void onMouseClick(MouseEvent e) {

    if (this._currentImage != null) {
      int offsetX = this._viewport.xOffset;
      int offsetY = this._viewport.yOffset;

      int cursorX = e.clientX - this._page.canvasManager.offsetX;
      int cursorY = e.clientY - this._page.canvasManager.offsetY;

      int x = cursorX + offsetX;
      int y = cursorY + offsetY;

      int row = y ~/ 64;
      int col = x ~/ 64;

      this._region.setTile(row, col, this._currentImage.imgKey);
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

    int i;
    for (i = 0; i < this._region.height; i++) {
      this._viewport.drawLine(0, i * 64, 64 * this._region.width, i * 64);
      this._viewport.drawLine(0, i * 64 + 16, 64 * this._region.width, i * 64 + 16, CanvasDrawer.DASHED);
      this._viewport.drawLine(0, i * 64 + 32, 64 * this._region.width, i * 64 + 32, CanvasDrawer.DASHED);
      this._viewport.drawLine(0, i * 64 + 48, 64 * this._region.width, i * 64 + 48, CanvasDrawer.DASHED);
    }
    this._viewport.drawLine(0, i * 64, 64 * this._region.width, i * 64);
    for (i = 0; i < this._region.width; i++) {
      this._viewport.drawLine(i * 64, 0, i * 64, this._region.height * 64);
      this._viewport.drawLine(i * 64 + 16, 0, i * 64 + 16, 64 * this._region.height, CanvasDrawer.DASHED);
      this._viewport.drawLine(i * 64 + 32, 0, i * 64 + 32, 64 * this._region.height, CanvasDrawer.DASHED);
      this._viewport.drawLine(i * 64 + 48, 0, i * 64 + 48, 64 * this._region.height, CanvasDrawer.DASHED);
    }
    this._viewport.drawLine(i * 64, 0, i * 64, this._region.height * 64);


    if (this._currentImage != null && this._showImageOnCanvas) {
      d.drawImage(this._currentImage,
          this._imageX - this._viewport.xOffset % 64,
          this._imageY - this._viewport.yOffset % 64,
          64, 64);
    }
  }
}