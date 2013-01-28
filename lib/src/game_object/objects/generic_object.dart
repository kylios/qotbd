part of game_object;

class GenericObject extends GameObject {

  GenericObject(Image img, int x, int y, int width, int height, bool blocking) :
    super(img, x, y, width, height, blocking) {
  }

  List toArray() {
    return [ this.image.imgKey, this.x, this.y, this.width, this.height, this.blocking];
  }

  void tick() {}
}
