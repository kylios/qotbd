library level_builder;

import 'dart:html';
import 'package:quest/page.dart';
import 'package:quest/viewport.dart';
import 'package:quest/assets.dart';
import 'package:quest/level.dart';



class LevelBuilder extends MouseListener {

  Page _page;
  Viewport _viewport;

  Image _currentImage = null;
  bool _drawing = false;
  bool _moving = false;

  bool _showImageOnCanvas = false;
  int _imageX = 0;
  int _imageY = 0;

  List<String> _colors = [ "white", "red", "orange", "yellow", "green", "blue", "purple", "black" ];
  int _colorIdx = 0;

  Region _region = null;

  LevelBuilder(this._page, AssetManager imageList) {
    this._region = new EditableRegion("level1", "test region", imageList);
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
  }

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
  void onMouseClick(MouseEvent e) {}


  void draw() {

    CanvasDrawer d = this._page.canvasDrawer;
    d.clear(this._page.canvasManager);

    for (int i = 0; i < 20; i++) {
      this._viewport.drawLine(0, i * 64, 64 * 20, i * 64);
      this._viewport.drawLine(i * 64, 0, i * 64, 20 * 64);
    }


    if (this._currentImage != null && this._showImageOnCanvas) {
      d.drawImage(this._currentImage,
          this._imageX - this._viewport.xOffset % 64,
          this._imageY - this._viewport.yOffset % 64,
          64, 64);
    }
  }
}