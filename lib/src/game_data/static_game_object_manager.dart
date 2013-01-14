part of game_object;



class StaticGameObjectManager implements GameObjectManager {

  Map<int, Map<int, List<GameObject>>> _blockingObjects;
  int _currentLayer = 0;

  // This data structure should hold a reference to all blocking objects in the
  List<List<GameObject>> _objects;

  StaticGameObjectManager() {
    this._blockingObjects = new Map<int, Map<int, List<GameObject>>>();
    this._objects = new List<List<GameObject>>();
  }



  void newLayer() {
    if (this._currentLayer != 0 || this._objects.length != 0) {
      this._currentLayer++;
    }

    // Make sure that there's always a current layer to add objects to
    if (this._currentLayer >= this._objects.length ||
        this._objects[this._currentLayer] == null) {
      this._objects.add(new List<GameObject>());
    }
  }
  void layerFirst() {
    this._currentLayer = 0;
  }
  bool hasNextLayer() {
    return this._currentLayer < this._objects.length;
  }

  List<GameObject> get layer => (this._objects.length > this._currentLayer ?
      this._objects[this._currentLayer] : new List<GameObject>());

  void add(GameObject o) {

    this._objects[this._currentLayer].add(o);
    if (o.blocking) {

      // 16 pixel grid for collision detection.  Our movement vector cannot
      // exceed 16 pixels for a single tick.
      int x = o.x ~/ 16;
      int y = o.y ~/ 16;

      if (this._blockingObjects[y] == null) {
        this._blockingObjects[y] =
            new Map<int, List<GameObject>>();
      }
      if (this._blockingObjects[y][x] == null) {
        this._blockingObjects[y][x] = new List<GameObject>();
      }
      this._blockingObjects[y][x].add(o);
    }
  }

  void remove(int row, int col) {
    return;
  }

  Iterator<GameObject> iterator() {
    return new StaticGameObjectIterator(this);
  }

  List<GameObject> getNearbyBlockingObjects(int x, int y) {

    int col = x ~/ 16;
    int row = y ~/ 16;

    List<GameObject> objs = new List<GameObject>();

    for (int r = row - 5; r < row + 9; r++) {
      if (this._blockingObjects[r] != null) {
        for (int c = col - 5; c < col + 9; c++) {
          if (this._blockingObjects[r][c] != null) {
            objs.addAll(this._blockingObjects[r][c]);
          }
        }
      }
    }

    objs.forEach((GameObject o) =>
        window.console.log("Blocking object at ${o.x}x${o.y} named ${o.image.imgKey}"));

    return objs;
  }
}

class StaticGameObjectIterator implements Iterator<GameObject> {

  List<GameObject> _objects;
  Iterator<GameObject> _iterator;

  StaticGameObjectIterator(StaticGameObjectManager m) {
    this._objects = new List<GameObject>();
    for (List<GameObject> l in m._objects) {
      for (GameObject g in l) {
        this._objects.add(g);
      }
    }
    this._iterator = this._objects.iterator();
  }

  GameObject next() {
    return this._iterator.next();
  }

  bool get hasNext => this._iterator.hasNext;
}
