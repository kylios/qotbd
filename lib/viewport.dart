library viewport;

import 'package:quest/assets.dart';
import 'package:quest/page.dart';

class Viewport {

  int _offsetX = 0;
  int _offsetY = 0;

  int _viewWidth = 0;
  int _viewHeight = 0;

  CanvasDrawer _drawer;

  Viewport(this._drawer, this._viewWidth, this._viewHeight);

  void setOffset(int x, int y) {
    this._offsetX = x;
    this._offsetY = y;
  }

  void drawImage(Image image, int x, int y, int width, int height) {

    if (x + width < this._offsetX || x > this._offsetX + this._viewWidth ||
        y + height < this._offsetY || y > this._offsetY + this._viewHeight) {

      return;
    }

    int drawX = x - this._offsetX;
    int drawY = y - this._offsetY;

    this._drawer.drawImage(image, drawX, drawY, width, height);
  }
}
