part of level;

class EditableRegion extends Region {

  Map<int, Map<int, List<GameObject>>> _objects;
  List<List<String>> _tiles = null;
  int _width = 0;
  int _height = 0;
  int _rows = 0;
  int _cols = 0;

  EditableRegion(String levelName, String regionName, AssetManager imageAssets)
      : super.fromEditable(levelName, regionName, imageAssets) {
    this._tiles = new List<List<String>>();
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

    Map<int, Map<int, List<GameObject>>> theObjects =
        new Map<int, Map<int, List<GameObject>>>();
    for (int r = 0; r < this._rows; r++) {
      Map<int, List<GameObject>> row = new Map<int, List<GameObject>>();
      for (int c = 0; c < this._cols; c++) {
        row[c] = new List<GameObject>();
      }
      theObjects[r] = row;
    }
    this._objects = theObjects;
  }

  void setTile(int row, int col, String imgKey) {
    if (row >= 0 && col >= 0 &&
        row < this._rows && col < this._cols) {
      this._tiles[row][col] = imgKey;
    }
  }

  void addObject(GameObject obj, int row, int col) {
    if (this.getObjectsAt(row, col) != null) {
      this._objects[row][col].add(obj);
    }
  }

  List<GameObject> getObjectsAt(int row, int col) {
    if (null == this._objects[row]) {
      return null;
    }
    return this._objects[row][col];
  }
}
