part of level;

class Region {

  String _levelName;
  String _regionName;

  AssetManager _assets;

  var _loadCallback;

  List<List<String>> _tiles;
  GameObjectManager _staticObjects;

  Region(this._levelName, this._regionName, this._assets) {

    this._staticObjects = new GameObjectManager();
    this._assets.addJsonData(this._regionName,
        'game_data/quest/levels/${this._levelName}/regions/${this._regionName}.json');
  }
  Region.fromEditable(this._levelName, this._regionName, this._assets){
    this._staticObjects = new GameObjectManager();
  }

  void onLoad(JsonData regionData, AssetManager assets) {

    Map data = regionData.data;
    this._tiles = data['tiles'];

    List<List<List>> staticObjects = data['static_objects'];
    for (List<List> layer in staticObjects) {
      this._staticObjects.newLayer();
      for (List objectData in layer) {
        Image i = assets.getImage(objectData[0]);
        window.console.log("${objectData[0]}: ${i.toString()}");
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

  List<List<String>> get tiles => this._tiles;
  GameObjectManager get staticObjects => this._staticObjects;
}
