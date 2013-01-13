part of game_object;

abstract class GameObjectManager implements Iterable {

  /**
   * Creates a new layer of objects in the object manager.  Layers are
   * distinguished for drawing purposes only.
   */
  void newLayer();

  /**
   * Reset the layer pointer back to the first one.  Any objects you add will
   * be added to the first layer, and the object's 'layer' property will return
   * the first layer.
   */
  void layerFirst();

  /**
   * Returns true if there is another layer after the current one.
   */
  bool hasNextLayer();

  /**
   * Add a game object to the current layer.
   */
  void add(GameObject o);

  /**
   * Remove all objects at the given row and col.
   */
  void remove(int row, int col);

  /**
   * Equals a list containing all the game objects on the current layer.
   */
  List<GameObject> get layer;

  List<GameObject> get blockingObjects;
}
