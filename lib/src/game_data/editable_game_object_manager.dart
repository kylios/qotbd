part of game_object;

class EditableGameObjectManager implements GameObjectManager {

  Map<int, Map<int, List<GameObject>>> _objects;
  int _layer = 0;

  EditableGameObjectManager() {

    this._objects = new Map<int, Map<int, List<GameObject>>>();
  }

  void newLayer() {
    this._layer++;
  }
  void layerFirst() {
    this._layer = 0;
  }
  bool hasNextLayer() {
    return this._layer < this._objects.keys.reduce(0,
        (prev, val) => (prev > val ? prev : val));
  }

  List<GameObject> get layer {
    List<GameObject> layer = new List<GameObject>();
    for (Map<int, List<GameObject>> row in this._objects.values){

      for (List<GameObject> objects in row.values) {

        if (objects[this._layer] != null ) {
          layer.add(objects[this._layer]);
        }
      }
    }
    return layer;
  }

  List<GameObject> get blockingObjects {

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

    return new EditableGameObjectIterator(this);
  }
}

class EditableGameObjectIterator extends Iterator<GameObject> {

  List<GameObject> _objects;
  Iterator<GameObject> _iterator;

  EditableGameObjectIterator(EditableGameObjectManager objects) {

    window.console.log("Creating EditableGameObjectIterator");
    this._objects = objects.layer;
    this._iterator = this._objects.iterator();

    window.console.log("Constructed");
  }

  bool get hasNext => this._iterator.hasNext;

  GameObject next() {
    return this._iterator.next();
  }
}
