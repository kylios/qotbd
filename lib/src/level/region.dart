part of level;

class Region {

  Level _level;

  String _regionName;

  AssetManager _tileImages;
  AssetManager _objectImages;

  List<List<String>> _tiles;
  GameObjectManager _staticObjects;

  Region.inLevel(this._level, this._tileImages, this._objectImages, this._regionName, Map data) {

    this._staticObjects = new StaticGameObjectManager();

    this._tiles = data['tiles'];

    List<List<List>> staticObjects = data['static_objects'];
    for (List<List> layer in staticObjects) {
      this._staticObjects.newLayer();
      for (List objectData in layer) {
        Image i = this._objectImages.getImage(objectData[0]);
        GameObject obj = new GenericObject(
            i,
            objectData[1],
            objectData[2],
            objectData[3],
            objectData[4],
            objectData[5]
            );
        this._staticObjects.add(obj);
      }
    }
  }

  Region.fromEditable(this._regionName);

  void drawTiles(Viewport v) {

    int row = 0;
    int col = 0;
    for (List<String> levelRow in this.tiles) {
      col = 0;
      for (String imgKey in levelRow) {
        if (imgKey != null) {
          Tile t = new Tile(this._tileImages.getImage(imgKey));
          v.drawImage(t.image, 64 * col, 64 * row, 64, 64);
        }
        col++;
      }
      row++;
    }
  }

  void drawObjects(Viewport v) {

    for (GameObject o in this.staticObjects /* objects */) {
      if (o != null) {
        v.drawImage(o.image, o.x, o.y, o.width, o.height);
      }
    }
  }

  List<List<String>> get tiles => this._tiles;
  GameObjectManager get staticObjects => this._staticObjects;
  set staticObjects(GameObjectManager m) => this._staticObjects = m;

  String toJson() {

  }
}
