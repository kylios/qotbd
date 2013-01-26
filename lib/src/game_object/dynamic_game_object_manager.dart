part of game_object;


/**
 * Manages a list of objects who's positions can change.
 */
class DynamicGameObjectManager implements GameObjectManager //, GameObjectMoveListener
{
  // Plain list of the objects.  Outer list is the layer, inner list are the
  // objects at that layer.
  List<List<GameObject>> _objects = null;

  int _currentLayer = 0;

  // TODO: some data structure that can efficiently index elements by x,y and
  // efficiently re-index elements when they move around.

  /**
   * TODO: implement this.
   * Triggered when an object moves.
   */
  void onObjectMoved(GameEvent e) {
  }

  /**
   * Creates a new layer of objects in the object manager.  Layers are
   * distinguished for drawing purposes only.
   */
  void newLayer() {
  }

  /**
   * Reset the layer pointer back to the first one.  Any objects you add will
   * be added to the first layer, and the object's 'layer' property will return
   * the first layer.
   */
  void layerFirst() {
  }

  /**
   * Returns true if there is another layer after the current one.
   */
  bool hasNextLayer() {
  }

  /**
   * Add a game object to the current layer.
   */
  void add(GameObject o) {
  }

  /**
   * Remove all objects at the given row and col.
   */
  void remove(int row, int col) {
  }

  /**
   * Equals a list containing all the game objects on the current layer.
   */
  List<GameObject> get layer {
  }

  /**
   * Get blocking objects close to the given coordinates.
   */
  List<GameObject> getNearbyBlockingObjects(int x, int y) {

  }

  Iterator<GameObject> iterator() {

  }
}
