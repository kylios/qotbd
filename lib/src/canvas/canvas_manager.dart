part of page;

class CanvasManager {

  CanvasElement _canvas;
  CanvasRenderingContext2D _c;

  int _width;
  int _height;

  CanvasManager(this._canvas, {int width: 640, int height: 480}) {

    this._c = this._canvas.getContext("2d");
    this._width = width;
    this._height = height;

    this.resize(width, height);
  }

  int get width => this._width;
  int get height => this._height;

  void resize(int width, int height) {

    // Set the canvas size.
    // Note: if the style and attributes don't match, the canvas will not be
    //  scaled 1:1 and will look funny.
    this._canvas.style.width = "${this._width.toString()}px";
    this._canvas.style.height = "${this._height.toString()}px";

    this._canvas.attributes['width'] = this._width.toString();
    this._canvas.attributes['height'] = this._height.toString();
  }

}
