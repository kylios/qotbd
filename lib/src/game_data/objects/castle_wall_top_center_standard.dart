part of game_data;

class CastleWallTopCenterStandard extends GameObject {

  CastleWallTopCenterStandard(AssetManager assets, int x, int y) :
    super(assets.getImage('cwstc'), x, y, 64, 64, false) {

  }

  void tick() {
    return;
  }
}
