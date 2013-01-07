part of assets;

class Image {

  ImageElement img;
  String _imgKey = null;
  bool _ready = false;
  var _onReady = null;

  Image(String src, this._imgKey, [var onReady]) {
    this.img = new ImageElement();
    this.img.on.load.add(this._setReady);
    this.img.src = src;
    if (?onReady) {
      this._onReady = onReady;
    }
  }

  void _setReady( Event _ ) {

    this._ready = true;
    if (this._onReady != null) {
      this._onReady(this);
    }
  }

  bool isReady() {
    return this._ready;
  }

  String get imgKey => this._imgKey;
}