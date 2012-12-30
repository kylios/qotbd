part of game_data;

class CastleWallRoofCenterStandard extends GameObject {

  CastleWallRoofCenterStandard(AssetManager assets, int x, int y) :
    super(assets.getImage('cwsrc'), x, y, 64, 64, true) {

  }

  void tick() {
    return;
  }
}
