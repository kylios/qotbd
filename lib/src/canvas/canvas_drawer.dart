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

  void drawLine(int startX, int startY, int endX, int endY,
                [int lineStyle = CanvasDrawer.SOLID]) {

    this._c.strokeStyle = this._foregroundColor;
    this._c.moveTo(startX, startY);
    this._c.lineTo(endX, endY);
    this._c.stroke();
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
