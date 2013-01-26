library level_builder;

import 'dart:html';
import 'package:quest/level_builder.dart';
import 'package:quest/page.dart';
import 'package:quest/assets.dart';
import 'package:quest/tile.dart';
import 'package:quest/viewport.dart';

DivElement images = query('#images');

// The current image to place on the screen
List<ImageRecord> imageRecords = null;
DivElement imagesElem;

Page p;
Viewport v;
AssetManager assets;

Map game;
Map<String, Map<String, String>> imageURIMap;

LevelBuilder builder;

class ImageRecord {

  Image _image;
  DivElement _container;
  LevelBuilder _builder;

  ImageRecord(this._builder, this._image, this._container) {
    this._container.on.click.add(this._onClick);
  }

  void _onClick(MouseEvent e) {
    this._builder.currentImage = this._image;
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

void start(AssetManager _m) {

  for (String imgKey in imageURIMap['tiles'].keys) {

    Image i = _m.getImage(imgKey);

    addImageToList(i, imgKey, images);
  }
  for (String imgKey in imageURIMap['objects'].keys) {

    Image i = _m.getImage(imgKey);

    addImageToList(i, imgKey, images);
  }
  /*for (String imgKey in imageURIMap['player'].keys) {

    Image i = _m.getImage(imgKey);

    addImageToList(i, imgKey, images);
  }*/
}

void clickGo(MouseEvent e) {

  InputElement widthElem = query('#width');
  InputElement heightElem = query('#height');
  InputElement levelNameElem = query('#level_name');
  InputElement regionNameElem = query('#region_name');
  int width = int.parse(widthElem.value.toString());
  int height = int.parse(heightElem.value.toString());
  String levelName = levelNameElem.value.toString();
  String regionName = regionNameElem.value.toString();
  builder.start(levelName, regionName, width, height);
}

void place(Event e) {

  InputElement el = e.target;
  if (el.value == 'tiles') {
    builder.placeTiles = true;
    builder.placeObjects = false;
  } else if (el.value == 'objects') {
    builder.placeObjects = true;
    builder.placeTiles = false;
  }
}

void gameLoaded(AssetManager _m) {

  // Fetch the data
  game = _m.getJson('game').data;
  imageURIMap = _m.getJson('imageURIMap').data;

  imagesElem = query('#images');

  query('#go').on.click.add(clickGo);
  query('#export').on.click.add((Event e) => query('#json').innerHtml = builder.export());
  query('#json').on.click.add((Event e) => query('#json').nodes[0]);
  query('#erase').on.click.add((Event e) => builder.erase());
  query('#blocking').on.change.add((Event e) {
    InputElement el = e.target;
    if (el.checked) {
      builder.blocking = true;
    } else {
      builder.blocking = false;
    }
  });
  queryAll('[name="place"]').forEach((InputElement e) {
    e.on.click.add(place);
  });

  // Set new callback to fire when new assets are loaded
  //assets.setLoadCallback(start);

  // Load images
  for (String imgKey in imageURIMap['tiles'].keys) {
    String uri = imageURIMap['tiles'][imgKey];
    _m.addImage(imgKey, uri);
  }
  for (String imgKey in imageURIMap['objects'].keys) {
    String uri = imageURIMap['objects'][imgKey];
    _m.addImage(imgKey, uri);
  }
  /*for (String imgKey in imageURIMap['player'].keys) {
    String uri = imageURIMap['player'][imgKey];
    _m.addImage(imgKey, uri);
  }*/

  /*
  // Load level file
  gameLevels = new Map<String, Level>();
  for (String levelName in game['levels']) {
    gameLevels[levelName] = null;
  }

  gameLevels[game['levels'][0]] = new Level(assets, game['levels'][0], levelLoaded);
  */

  _m.load().then(start);
}

void main() {

  p = new Page();
  //p.manageCanvas(query('canvas'), 640, 480, true);
  CanvasManager mgr = new CanvasManager(query('canvas'),
      width: 640, height: 480, hidden: true);
  CanvasDrawer drw = mgr.drawer;

  assets = new AssetManager();
  builder = new LevelBuilder(p, mgr, assets);
  imageRecords = new List<ImageRecord>();

  drw.setBackground('black');
  drw.setForeground('white');


  v = new Viewport(drw, 640, 480, 64 * 20, 64 * 20, true);


  // Load the image uri map
  assets.addJsonData('game', 'game_data/quest/game.json');
  assets.addJsonData('imageURIMap', 'game_data/quest/builder/image_uri_map.json');
  assets.load().then(gameLoaded);
}

