part of level;

class EditableRegion extends Region {

  List<List<String>> _tiles = null;
  int _width = 0;
  int _height = 0;
  int _rows = 0;
  int _cols = 0;
  GameObjectManager staticObjects;

  EditableRegion(String levelName, String regionName, AssetManager imageAssets)
      : super.fromEditable(levelName, regionName, imageAssets) {
    this._tiles = new List<List<String>>();
    this.staticObjects = new EditableGameObjectManager();
    this.staticObjects.newLayer();
  }

  int get width => this._width;
  int get height => this._height;
  int get rows => this._rows;
  int get cols => this._cols;

  void start(int width, int height) {

    this._rows = height;
    this._cols = width;

    this._height = height * 64;
    this._width = width * 64;

    List<List<String>> theRows = new List<List<String>>(this._rows);
    for (int r = 0; r < this._rows; r++ ) {
      List<String> row = new List<String>(this._cols);
      for (int c = 0; c < this._cols; c++) {
        row[c] = null;
      }
      theRows[r] = row;
    }
    this._tiles = theRows;
  }

  void setTile(int row, int col, String imgKey) {
    if (row >= 0 && col >= 0 &&
        row < this._rows && col < this._cols) {
      this._tiles[row][col] = imgKey;
    }
  }

  void clearTile(int row, int col) {
    if (row >= 0 && col >= 0 &&
        this._tiles.length > row && this._tiles[0].length > col) {
      this._tiles[row][col] = null;
    }
  }

  void addObject(GameObject o) {
    if (this._staticObjects == null) {
      window.console.log("static objects is null");
      return;
    }
    window.console.log("Adding ${o.toString()} to static objects");
    this.staticObjects.add(o);
  }

  void removeObject(int row, int col) {
    if (this._staticObjects == null) {
      return;
    }
    this.staticObjects.remove(row, col);
  }

  String toJson() {

    Map json = new Map();

    List<List<List>> layers = new List<List<List>>();

    bool added = true;
    int i = 0;
    this.staticObjects.layerFirst();
    while (this.staticObjects.hasNextLayer()) {
      layers.add(this.staticObjects.layer.map(
          // Convert the GameObject to a json object
          // (TODO: this could be part of a GameObject.export() function)
          (GameObject o) => o.toArray()));
      this.staticObjects.newLayer();
      i++;
    }

    json["tiles"] = this._tiles;
    json['static_objects'] = layers;

    return JSON.stringify(json);
  }
}
