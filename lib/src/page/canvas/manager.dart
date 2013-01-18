part of page;

class CanvasManager {

  CanvasElement _canvas;
  CanvasRenderingContext2D _c;

  int _width;
  int _height;

  List<KeyboardListener> _keyboardListeners;
  List<MouseListener> _mouseListeners;

  CanvasManager(CanvasElement canvas,
      {int width: 640, int height: 480, bool hidden: false}) {

    this._keyboardListeners = new List<KeyboardListener>();
    this._mouseListeners = new List<MouseListener>();

    this._canvas = canvas;

    //this._canvas.on.contextMenu.remove();
    this._c = this._canvas.getContext("2d");
    this._width = width;
    this._height = height;
    if (hidden) {
      this.hide();
    } else {
      this.show();
    }

    this.resize(width, height);
  }

  CanvasDrawer get drawer => new CanvasDrawer._fromManager(this._c);

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

  }

  void hide() {
    this._canvas.hidden = true;
  }
  void show() {
    this._canvas.hidden = false;
  }

  void addKeyboardListener(KeyboardListener l) {
    this._canvas.on.keyDown.add(l.onKeyDown);
    this._canvas.on.keyUp.add(l.onKeyUp);
    this._canvas.on.keyPress.add(l.onKeyPress);
  }
  void addMouseListener(MouseListener l) {
    this._canvas.on.click.add(l.onMouseClick);
    this._canvas.on.mouseMove.add(l.onMouseMove);
    this._canvas.on.mouseOver.add(l.onMouseOver);
    this._canvas.on.mouseOut.add(l.onMouseOut);
  }



}
