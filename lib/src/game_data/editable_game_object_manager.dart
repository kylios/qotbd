part of game_object;

class EditableGameObjectManager implements GameObjectManager {

  Map<int, Map<int, List<GameObject>>> _objects;

  EditableGameObjectManager() {

    this._objects = new Map<int, Map<int, List<GameObject>>>();
  }

  void newLayer() {
    return;
  }

  void add(GameObject o) {

    int row = o.y ~/ 16;
    int col = o.x ~/ 16;

    if (this._objects[row] == null) {
      this._objects[row] = new Map<int, List<GameObject>>();
    }
    if (this._objects[row][col] == null) {
      this._objects[row][col] = new List<GameObject>();
    }
    this._objects[row][col].add(o);
  }

  Iterator<GameObject> iterator() {

    return new EditableGameObjectIterator(this._objects);
  }
}

class EditableGameObjectIterator extends Iterator<GameObject> {

  List<GameObject> _objects;
  Iterator<GameObject> _iterator;

  EditableGameObjectIterator(Map<int, Map<int, List<GameObject>>> objects) {

    this._objects = new List<GameObject>();

    for (Map<int, List<GameObject>> row in objects.values) {
      if (row == null) {
        continue;
      }
      for (List<GameObject> stack in row.values) {
        if (stack == null) {
          continue;
        }
        for (GameObject o in stack) {
          this._objects.add(o);
        }
      }
    }
    this._iterator = this._objects.iterator();
  }

  bool get hasNext => this._iterator.hasNext;

  GameObject next() {
    return this._iterator.next();
  }
}
