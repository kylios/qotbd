library image_list;

import 'package:quest/assets.dart';

class ImageList {

  int cur = 0;
  List<Image> _images;

  ImageList(this._images);

  Image getImage() {
    return this._images[this.cur];
  }

  void tick() {
    this.cur++;
    if (this.cur >= this._images.length) {
      this.cur = 0;
    }
  }

  void reset() {
    this.cur = 0;
  }
}
