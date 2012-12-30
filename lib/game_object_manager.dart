part of game_object;



class GameObjectManager {

  List<GameObject> _nonBlockingObjects;
  List<GameObject> _blockingObjects;
  List<GameObject> _objects;

  GameObjectManager() {
    this._nonBlockingObjects = new List<GameObject>();
    this._blockingObjects = new List<GameObject>();
    this._objects = new List<GameObject>();
  }

  void add(GameObject o) {
    /*if (o.blocking) {
      this._blockingObjects.add(o);
    } else {
      this._nonBlockingObjects.add(o);
    }*/
    this._objects.add(o);
  }

  Iterator<GameObject> iterator() {
    return this._objects.iterator();
    return new GameObjectIterator(this);
  }

  List<GameObject> get nonBlockingObjects => this._nonBlockingObjects;
  List<GameObject> get blockingObjects => this._blockingObjects;
}

class GameObjectIterator implements Iterator<GameObject> {

  Iterator<GameObject> _blockingIt;
  Iterator<GameObject> _nonBlockingIt;

  GameObjectIterator(GameObjectManager m) {
    this._blockingIt = m._blockingObjects.iterator();
    this._nonBlockingIt = m._nonBlockingObjects.iterator();
  }
  GameObject next() {
    if (this._blockingIt.hasNext) {
      return this._blockingIt.next();
    } else {
      return this._nonBlockingIt.next();
    }
  }

  bool get hasNext => this._blockingIt.hasNext || this._nonBlockingIt.hasNext;
}
