part of game_object;

class GenericObject extends GameObject {

  GenericObject(Image img, int x, int y, int width, int height, bool blocking) :
    super(img, x, y, width, height, blocking) {

  }

  void tick() {}
}
