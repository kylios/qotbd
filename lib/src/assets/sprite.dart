part of assets;

class Sprite {

  Image _image;

  int _xOffset;
  int _yOffset;
  int _width;
  int _height;

  Sprite(this._image,
      this._xOffset, this._yOffset, this._width, this._height);

  Image get image => this._image;
  int get xOffset => this._xOffset;
  int get yOffset => this._yOffset;
  int get width => this._width;
  int get height => this._height;
}