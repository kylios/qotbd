part of game_object;



class StaticGameObjectManager implements GameObjectManager {

  List<Map<int, Map<int, GameObject>>> _objects;
  int _currentLayer = 0;
  List<GameObject> _blockingObjects;

  StaticGameObjectManager() {
    this._objects = new List<Map<int, Map<int, GameObject>>>();
    this._blockingObjects = new List<GameObject>();
  }



  void newLayer() {
    if (this._currentLayer == 0 && this._objects.length == 0) {
      return;
    }
    this._currentLayer++;
  }
  void layerFirst() {
    this._currentLayer = 0;
  }

  List<GameObject> get layer {
    List<List<GameObject>> layer = new List<List<GameObject>>();
  }

  void add(GameObject o) {
    if (o.blocking) {
      this._blockingObjects.add(o);
    }
    while (this._objects.length <= this._currentLayer) {
      this._objects.add(new Map<int, Map<int, GameObject>>());
    }

    int x = o.x ~/ 16;
    int y = o.y ~/ 16;

    if (this._objects[this._currentLayer][y] == null) {
      this._objects[this._currentLayer][y] = new Map<int, GameObject>();
    }
    this._objects[this._currentLayer][y][x] = o;
  }

  Iterator<GameObject> iterator() {
    return new StaticGameObjectIterator(this);
  }

  List<GameObject> get blockingObjects => this._blockingObjects;

}

class StaticGameObjectIterator implements Iterator<GameObject> {

  List<GameObject> _objects;
  Iterator<GameObject> _iterator;

  StaticGameObjectIterator(StaticGameObjectManager m) {
    this._objects = new List<GameObject>();
    for (Map<int, Map<int, GameObject>> l in m._objects) {
      for (int r_idx in l.keys) {
        Map<int, GameObject> row = l[r_idx];
        if (row == null) {
          continue;
        }
        for (int g_idx in row.keys) {
          GameObject g = row[g_idx];
          if (g != null) {
            this._objects.add(g);
          }
        }
      }
    }
    this._iterator = this._objects.iterator();
  }

  GameObject next() {
    return this._iterator.next();
  }

  bool get hasNext => this._iterator.hasNext;
}
