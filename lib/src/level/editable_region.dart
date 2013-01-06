part of level;

class EditableRegion extends Region {

  List<List<String>> _tiles = null;

  EditableRegion(String levelName, String regionName, AssetManager imageAssets)
      : super.fromEditable(levelName, regionName, imageAssets) {
    this._tiles = new List<List<String>>();
  }

  void start(int width, int height) {

    int rows = height ~/ 64;
    int cols = width ~/ 64;

    List<List<String>> theRows = new List<List<String>>();
    for (int r = 0; r < rows; r++ ) {
      List<String> row = new List<String>(cols.length);
      for (int c = 0; c < cols; c++) {

      }
      theRows.add(col);
    }
  }
}
