part of assets;

class SpriteAnimation {

  int _curFrame = 0;

  List<List<int>> _frames = null;

  SpriteAnimation.fromJson(List json) {

    this._frames = new List<List<int>>();

    for (List<int> l in json) {
      int xOffset = l[0];
      int yOffset = l[1];
      int width = l[2];
      int height = l[3];

      this._frames.add([ xOffset, yOffset, width, height]);
    }
  }

  List<int> getFrame() {
    return this._frames[this._curFrame];
  }

  void tick() {
    this._curFrame++;
    if (this._curFrame >= this._frames.length) {
      this._curFrame = 0;
    }
  }

  void reset() {
    this._curFrame = 0;
  }
}
