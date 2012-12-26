part of page;

class CanvasDrawer {

  CanvasRenderingContext2D _c;

  CanvasDrawer(this._c);

  void drawTile(Tile t, int x, int y, int width, int height) {
    _c.drawImage(t.image.img, x, y, width, height);
  }
}
