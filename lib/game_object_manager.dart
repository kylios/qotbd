part of game_object;



class GameObjectManager {

  List<Map<int, Map<int, GameObject>>> _objects;
  Map<int, Map<int, GameObject>> _currentLayer = null;
  List<GameObject> _blockingObjects;

  GameObjectManager() {
    this._objects = new List<Map<int, Map<int, GameObject>>>();
    this._blockingObjects = new List<GameObject>();
  }

  void newLayer() {
    this._currentLayer = new Map<int, Map<int, GameObject>>();
    this._objects.add(this._currentLayer);
  }

  void add(GameObject o) {
    if (o.blocking) {
      this._blockingObjects.add(o);
    }
    if (this._currentLayer == null) {
      return;
    }
    int x = o.x ~/ 16;
    int y = o.y ~/ 16;

    if (this._currentLayer[y] == null) {
      this._currentLayer[y] = new Map<int, GameObject>();
    }
    this._currentLayer[y][x] = o;
  }

  Iterator<GameObject> iterator() {
    return new GameObjectIterator(this);
  }

  List<GameObject> get blockingObjects => this._blockingObjects;

}

class GameObjectIterator implements Iterator<GameObject> {

  List<GameObject> _objects;
  Iterator<GameObject> _iterator;

  GameObjectIterator(GameObjectManager m) {
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
