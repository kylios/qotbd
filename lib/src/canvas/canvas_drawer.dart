part of page;

class CanvasDrawer {

  String _backgroundColor = 'white';

  CanvasRenderingContext2D _c;

  CanvasDrawer(this._c);

  void drawImage(Image i, int x, int y, int width, int height) {
    this._c.drawImage(i.img, x, y, width, height);
  }

  void setBackground(String backgroundColor) {
    this._backgroundColor = backgroundColor;
    this._c.fillStyle = this._backgroundColor;
  }

  void clear(CanvasManager mgr) {
    this._c.fillRect(0, 0, mgr.width, mgr.height);
  }
}
