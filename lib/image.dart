library image;

import 'dart:html';

class Image {

  ImageElement img;
  bool _ready = false;
  var _onReady = null;

  Image(String src, [var onReady]) {
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
}