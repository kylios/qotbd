library quest_level_builder;

import 'dart:html';
import 'package:quest/page.dart';
import 'package:quest/assets.dart';
import 'package:quest/tile.dart';
import 'package:quest/viewport.dart';
import 'package:quest/level_builder.dart';

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

