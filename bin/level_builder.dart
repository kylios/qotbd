library level_builder;

import 'dart:html';
import 'package:quest/page.dart';
import 'package:quest/assets.dart';
import 'package:quest/tile.dart';
import 'package:quest/viewport.dart';

DivElement images = query('#images');

// The current image to place on the screen
List<ImageRecord> imageRecords = null;

bool tileMode = true;
bool objectMode = false;

Page p;
Viewport v;
AssetManager assets;

Map game;
Map<String, String> imageURIMap;

LevelBuilder builder;

class ImageRecord {

  Image _image;
  DivElement _container;
  LevelBuilder _builder;

  ImageRecord(this._builder, this._image, this._container) {
    this._container.on.click.add(this._onClick);
  }

  void _onClick(MouseEvent e) {
    this._builder._currentImage = this._image;
  }
}

class LevelBuilder extends MouseListener {

  Page _page;
  Viewport _viewport;

  Image _currentImage = null;

  bool _showImageOnCanvas = false;
  int _imageX = 0;
  int _imageY = 0;

  LevelBuilder(this._page) {
    this._page.canvasManager.addMouseListener(this);
    this._viewport = new Viewport(this._page.canvasDrawer,
        640, 480, 64 * 20, 64 * 20, true);

    this.draw();
  }

  Image get currentImage => this._currentImage;

  void onMouseOver(MouseEvent e) {
    this._showImageOnCanvas = true;
  }
  void onMouseOut(MouseEvent e) {
    this._showImageOnCanvas = false;
  }
  void onMouseMove(MouseEvent e) {

    int cursorX = e.clientX - this._page.canvasManager.offsetX;
    int cursorY = e.clientY - this._page.canvasManager.offsetY;

    window.console.log("Corsor coords: (${cursorX}, ${cursorY})");

    this._imageX = (cursorX ~/ 64) * 64;
    this._imageY = (cursorY ~/ 64) * 64;

    if (cursorX <= 64) {
      this._viewport.setOffset(this._viewport.xOffset - 16, this._viewport.yOffset);
    } else if (cursorX >= this._viewport.viewWidth - 64) {
      this._viewport.setOffset(this._viewport.xOffset + 16, this._viewport.yOffset);
    }
    if (cursorY <= 64) {
      this._viewport.setOffset(this._viewport.xOffset, this._viewport.yOffset - 16);
    } else if (cursorY >= this._viewport.viewHeight - 64) {
      this._viewport.setOffset(this._viewport.xOffset, this._viewport.yOffset + 16);
    }

    this.draw();
  }
  void onMouseClick(MouseEvent e) {}


  void draw() {

    CanvasDrawer d = this._page.canvasDrawer;
    d.clear(this._page.canvasManager);

    for (int i = 0; i < 20; i++) {
      this._viewport.drawLine(0, i * 64, 64 * 20, i * 64);
      this._viewport.drawLine(i * 64, 0, i * 64, 20 * 64);
    }


    if (this._currentImage != null && this._showImageOnCanvas) {
      d.drawImage(this._currentImage, this._imageX, this._imageY, 64, 64);
    }
  }
}

void addImageToList(Image i, String imgKey, DivElement images) {

  DivElement newImg = new DivElement();
  newImg.classes = [ "img_container" ];
  SpanElement tag = new SpanElement();
  tag.classes = [ "img_title" ];
  tag.text = imgKey;
  newImg.nodes.add(tag);
  SpanElement imgArea = new SpanElement();
  imgArea.nodes.add(i.img);
  newImg.nodes.add(imgArea);

  imageRecords.add(new ImageRecord(builder, i, newImg));
  images.nodes.add(newImg);
}

void start() {

  for (String imgKey in imageURIMap.keys) {

    Image i = assets.getImage(imgKey);

    addImageToList(i, imgKey, images);
  }
}

void gameLoaded() {

  // Fetch the data
  game = assets.getJson('game').data;
  imageURIMap = assets.getJson('imageURIMap').data;

  // Set new callback to fire when new assets are loaded
  assets.setLoadCallback(start);

  // Load images
  for (String imgKey in imageURIMap.keys) {
    String uri = imageURIMap[imgKey];
    assets.addImage(imgKey, uri);
  }

  /*
  // Load level file
  gameLevels = new Map<String, Level>();
  for (String levelName in game['levels']) {
    gameLevels[levelName] = null;
  }

  gameLevels[game['levels'][0]] = new Level(assets, game['levels'][0], levelLoaded);
  */

  assets.load();
}

void main() {

  p = new Page();
  CanvasManager mgr = p.canvasManager;
  CanvasDrawer drw = p.canvasDrawer;

  builder = new LevelBuilder(p);
  imageRecords = new List<ImageRecord>();

  drw.setBackground('black');
  drw.setForeground('white');

  v = new Viewport(drw, 640, 480, 64 * 20, 64 * 20, true);

  assets = new AssetManager(gameLoaded);

  // Load the image uri map
  assets.addJsonData('game', 'game_data/quest/game.json');
  assets.addJsonData('imageURIMap', 'game_data/quest/image_uri_map.json');
  assets.load();
}

