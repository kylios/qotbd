part of level;

class EditableRegion extends Region {

  List<List<String>> _tiles = null;
  int _width = 0;
  int _height = 0;

  EditableRegion(String levelName, String regionName, AssetManager imageAssets)
      : super.fromEditable(levelName, regionName, imageAssets) {
    this._tiles = new List<List<String>>();
  }

  int get width => this._width;
  int get height => this._height;

  void start(int width, int height) {

    this._height = height;
    this._width = width;

    List<List<String>> theRows = new List<List<String>>(this._height);
    for (int r = 0; r < this._height; r++ ) {
      List<String> row = new List<String>(this._width);
      for (int c = 0; c < this._width; c++) {
        row[c] = null;
      }
      theRows[r] = row;
    }
    this._tiles = theRows;
  }

  void setTile(int row, int col, String imgKey) {
    if (row >= 0 && col >= 0 &&
        row < this._height && col < this._width) {
      this._tiles[row][col] = imgKey;
    }
  }
}
