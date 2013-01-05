part of page;

class CanvasManager {

  CanvasElement _canvas;
  CanvasRenderingContext2D _c;

  int _width;
  int _height;

  List<KeyboardListener> _keyboardListeners;
  List<MouseListener> _mouseListeners;



  CanvasManager(this._canvas, {int width: 640, int height: 480}) {

    this._c = this._canvas.getContext("2d");
    this._width = width;
    this._height = height;

    this.resize(width, height);

    this._keyboardListeners = new List<KeyboardListener>();
    this._mouseListeners = new List<MouseListener>();
  }

  int get width => this._width;
  int get height => this._height;

  int get offsetX => this._canvas.getBoundingClientRect().left.toInt() + window.pageXOffset.toInt() - document.documentElement.clientLeft.toInt();
  int get offsetY => this._canvas.getBoundingClientRect().top.toInt() + window.pageYOffset.toInt() - document.documentElement.clientTop.toInt();

  void resize(int width, int height) {

    // Set the canvas size.
    // Note: if the style and attributes don't match, the canvas will not be
    //  scaled 1:1 and will look funny.
    this._canvas.style.width = "${this._width.toString()}px";
    this._canvas.style.height = "${this._height.toString()}px";

    this._canvas.attributes['width'] = this._width.toString();
    this._canvas.attributes['height'] = this._height.toString();

    this._canvas.on.keyDown.add(this._onKeyDown);
    this._canvas.on.keyUp.add(this._onKeyUp);
    this._canvas.on.keyPress.add(this._onKeyPress);

    this._canvas.on.click.add(this._onClick);
    this._canvas.on.mouseMove.add(this._onMouseMove);
    this._canvas.on.mouseOver.add(this._onMouseOver);
    this._canvas.on.mouseOut.add(this._onMouseOut);
  }

  void addKeyboardListener(KeyboardListener l) {
    this._keyboardListeners.add(l);
  }
  void addMouseListener(MouseListener l) {
    this._mouseListeners.add(l);
  }

  void _onKeyDown(KeyboardEvent e) {
    for (KeyboardListener l in this._keyboardListeners) {
      l.onKeyDown(e);
    }
  }
  void _onKeyUp(KeyboardEvent e) {
    for (KeyboardListener l in this._keyboardListeners) {
      l.onKeyUp(e);
    }
  }
  void _onKeyPress(KeyboardEvent e) {
    for (KeyboardListener l in this._keyboardListeners) {
      l.onKeyPress(e);
    }
  }

  void _onClick(MouseEvent e) {
    for (MouseListener l in this._mouseListeners){
      l.onMouseClick(e);
    }
  }
  void _onMouseMove(MouseEvent e) {
    for (MouseListener l in this._mouseListeners){
      l.onMouseMove(e);
    }
  }
  void _onMouseOver(MouseEvent e) {
    for (MouseListener l in this._mouseListeners){
      l.onMouseOver(e);
    }
  }
  void _onMouseOut(MouseEvent e) {
    for (MouseListener l in this._mouseListeners){
      l.onMouseOut(e);
    }
  }

}
