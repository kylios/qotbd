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

  void addObject(GameObject o) {
    if (this._staticObjects == null) {
      return;
    }
    this._staticObjects.add(o);
  }

  String toJson() {

    Map json = new Map();

    List<List<List>> layers = new List<List<List>>();

    bool added = true;
    int i = 0;
    this.staticObjects.layerFirst();
    while (this.staticObjects.hasNextLayer()) {
      added = false;
      List<List> l = new List<List>();
      for (Map<int, List<GameObject>> row in this.staticObjects) {
        if (row == null) {
          continue;
        }
        for (List<GameObject> os in row.values) {
          if (os == null || os[i] == null) {
            continue;
          }
          GameObject o = os[i];
          l.add([
            o.image.imgKey,
            o.x, o.y, o.width, o.height, o.blocking
                 ]);
          added = true;
        }
      }
      layers.add(l);
      this.staticObjects.newLayer();
      i++;
    }

    json["tiles"] = this._tiles;
    json['static_objects'] = layers;

    return JSON.stringify(json);
  }
}
