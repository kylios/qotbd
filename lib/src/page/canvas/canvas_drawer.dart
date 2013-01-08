part of page;

class CanvasDrawer {

  static const int SOLID = 1;
  static const int DASHED = 2;


  String _backgroundColor = 'white';
  String _foregroundColor = 'black';

  CanvasRenderingContext2D _c;

  CanvasDrawer(this._c) {
    this._c.lineWidth = 1;
    this._c.lineDashOffset = 0;
  }

  void drawImage(Image i, int x, int y, int width, int height) {
    this._c.drawImage(i.img, x, y, width, height);
  }

  void _drawDashedLine(int startX, int startY, int endX, int endY) {

    int x1 = startX, x2 = endX, y1 = startY, y2 = endY;
    int lineWidth = 6;

    this._c.beginPath();
    this._c.moveTo(x1, y1);

    int dX = x2 - x1;
    int dY = y2 - y1;
    int dashes = sqrt(dX * dX + dY * dY).toInt() ~/ lineWidth;
    int dashX = dX ~/ dashes;
    int dashY = dY ~/ dashes;

    int q = 0;
    while (q++ < dashes) {
     x1 += dashX;
     y1 += dashY;
     if (q % 2 == 0) {
       this._c.moveTo(x1, y1);
     } else {
       this._c.lineTo(x1, y1);
     }
    }
    if (q % 2 == 0) {
      this._c.moveTo(x2, y2);
    } else {
      this._c.lineTo(x2, y2);
    }

    this._c.stroke();
    this._c.closePath();
  }

  void drawLine(int startX, int startY, int endX, int endY,
                [int lineStyle = CanvasDrawer.SOLID]) {

    if (startX == endX && startY == endY) {
      return;
    }

    if (lineStyle == CanvasDrawer.DASHED) {

      return this._drawDashedLine(startX, startY, endX, endY);
    } else {

      this._c.beginPath();
      this._c.moveTo(startX, startY);
      this._c.lineTo(endX, endY);
      this._c.closePath();
      this._c.stroke();
    }
  }

  void setForeground(String foregroundColor) {
    this._foregroundColor = foregroundColor;
    this._c.strokeStyle = this._foregroundColor;
  }

  void setBackground(String backgroundColor) {
    this._backgroundColor = backgroundColor;
    this._c.fillStyle = this._backgroundColor;
  }

  void clear(CanvasManager mgr) {
    this._c.fillRect(0, 0, mgr.width, mgr.height);
  }
}
