part of page;

abstract class EventListener {

  bool _enabled = false;
  void enableKeyEvents() {
    this._enabled = true;
  }
  void disableKeyEvents() {
    this._enabled = false;
  }

  void keyDown(KeyboardEvent e);
  void keyUp(KeyboardEvent e);
  void keyPressed(KeyboardEvent e);

  void onKeyDown(KeyboardEvent e) {
    if (this._enabled) {
      this.keyDown(e);
    }
  }
  void onKeyUp(KeyboardEvent e) {
    if (this._enabled) {
      this.keyUp(e);
    }
  }
  void onKeyPressed(KeyboardEvent e) {
    if (this._enabled) {
      this.keyPressed(e);
    }
  }
}

class EventHandler {

  static void addListener(EventListener l) {
    window.on.keyDown.add(l.onKeyDown);
    window.on.keyUp.add(l.onKeyUp);
    window.on.keyPress.add(l.onKeyPressed);
  }
}

