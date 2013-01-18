part of level;

class Region {

  String _levelName;
  String _regionName;

  AssetManager _tileImages;
  AssetManager _objectImages;
  AssetManager _assets;

  var _loadCallback;

  List<List<String>> _tiles;
  GameObjectManager _staticObjects;

  Region(this._levelName, this._regionName,
      this._assets, this._tileImages, this._objectImages) {

    this._staticObjects = new StaticGameObjectManager();
    this._assets.addJsonData(this._regionName,
        'game_data/quest/levels/${this._levelName}/regions/${this._regionName}.json');
  }

  Region.fromEditable(this._levelName, this._regionName, this._assets){
    this._staticObjects = new StaticGameObjectManager();
  }

  void onLoad(JsonData regionData) {

    Map data = regionData.data;
    this._tiles = data['tiles'];

    List<List<List>> staticObjects = data['static_objects'];
    for (List<List> layer in staticObjects) {
      this._staticObjects.newLayer();
      for (List objectData in layer) {
        Image i = this._objectImages.getImage(objectData[0]);
        window.console.log("${objectData[0]}: ${objectData[5]}");
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
