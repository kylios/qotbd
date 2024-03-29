library viewport;

import 'package:quest/assets.dart';
import 'package:quest/page.dart';

class Viewport {

  int _offsetX = 0;
  int _offsetY = 0;

  int _viewWidth = 0;
  int _viewHeight = 0;

  int _xBounds = 0;
  int _yBounds = 0;

  // Constrain offset to width and height
  bool _constrain = false;

  CanvasDrawer _drawer;

  Viewport(this._drawer,
      this._viewWidth, this._viewHeight,
      this._xBounds, this._yBounds,
      [this._constrain = false]);

  int get viewWidth => this._viewWidth;
  int get viewHeight => this._viewHeight;

  int get xOffset => this._offsetX;
  int get yOffset => this._offsetY;

  int get xBounds => this._xBounds;
  int get yBounds => this._yBounds;

  void setBounds(int xBounds, int yBounds) {
    this._xBounds = xBounds;
    this._yBounds = yBounds;
  }

  void setOffset(int x, int y) {
    if (this._constrain) {
      if (x < 0) {
        x = 0;
      }
      else if (x + this._viewWidth > this._xBounds) {
        x = this._xBounds - this._viewWidth;
      }
      if (y < 0) {
        y = 0;
      }
      else if (y + this._viewHeight > this._yBounds) {
        y = this._yBounds - this._viewHeight;
      }
    }

    this._offsetX = x;
    this._offsetY = y;
  }

  void drawSprite(Sprite s, int x, int y, int width, int height) {

    if (x + width < this._offsetX || x > this._offsetX + this._viewWidth ||
        y + height < this._offsetY || y > this._offsetY + this._viewHeight) {

      return;
    }

    int drawX = x - this._offsetX;
    int drawY = y - this._offsetY;

    this._drawer.drawSprite(s, drawX, drawY, width, height);
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

  void drawLine(int startX, int startY, int endX, int endY,
                [int lineStyle = CanvasDrawer.SOLID]) {

    int drawStartX = startX - this._offsetX;
    int drawStartY = startY - this._offsetY;
    int drawEndX = endX - this._offsetX;
    int drawEndY = endY - this._offsetY;

    this._drawer.drawLine(
        drawStartX, drawStartY, drawEndX, drawEndY,
        lineStyle);
  }
}
