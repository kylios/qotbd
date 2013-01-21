library quest;

import 'dart:html';

import 'package:quest/quest.dart';
import 'package:quest/page.dart';
//import 'package:quest/assets.dart';
//import 'package:quest/tile.dart';
//import 'package:quest/player.dart';
//import 'package:quest/image_list.dart';
import 'package:quest/game_data.dart';
import 'package:quest/viewport.dart';
//import 'package:quest/game_object.dart';
//import 'package:quest/level.dart';

final int TILE_WIDTH = 64;
final int TILE_HEIGHT = 64;
final int CANVAS_WIDTH = 640;
final int CANVAS_HEIGHT = 480;

Quest q;

Page p;
CanvasManager mgr;
CanvasDrawer drw;

//AssetManager assets;
Viewport v;
//Hero player;
//GameObjectManager objects;
//Map game;
//Level currentLevel;
//Map<String, Level> gameLevels;
//Region currentRegion;

//Map<String, Map<String, String>> imageURIMap = null;

double fpsAverage = 0.0;
num _renderTime = null;

void _loop(num _) {

  num time = new Date.now().millisecondsSinceEpoch;

  if (_renderTime != null) {
    //showFps((1000 / (time - this._renderTime)).round());
  }

  _renderTime = time;

  /*
  player.tick();

  // Collision detection
  for (GameObject o in
      currentRegion.staticObjects.getNearbyBlockingObjects(player.x, player.y)
      // objects.blockingObjects
      ) {

    int oX1 = o.x;
    int oX2 = o.x + o.width;
    int oY1 = o.y;
    int oY2 = o.y + o.height;

    int pX1 = player.x;
    int pX2 = player.x + 64;
    int pY1 = player.y;
    int pY2 = player.y + 64;

    int pX1_old = pX1 - player.moveX * player.speed;
    int pX2_old = pX2 - player.moveX * player.speed;
    int pY1_old = pY1 - player.moveY * player.speed;
    int pY2_old = pY2 - player.moveY * player.speed;

    bool zeroX = false;
    bool zeroY = false;
    bool corrected = false;

    if (player.moveX < 0 && pX1 <= oX2 && pX1_old > oX2 &&
        ((pY1 <= oY2 && pY1 >= oY1) || (pY2 <= oY2 && pY2 >= oY1)) &&
        ((pY1_old <= oY2 && pY1_old >= oY1) || (pY2_old <= oY2 && pY2_old >= oY1))) {
      zeroX = true;
    } else if (player.moveX > 0 && pX2 >= oX1 && pX2_old < oX1 &&
        ((pY1 <= oY2 && pY1 >= oY1) || (pY2 <= oY2 && pY2 >= oY1)) &&
        ((pY1_old <= oY2 && pY1_old >= oY1) || (pY2_old <= oY2 && pY2_old >= oY1))) {
      zeroX = true;
    }
    if (player.moveY < 0 && pY1 <= oY2 && pY1_old > oY2 &&
        ((pX1 <= oX2 && pX1 >= oX1) || (pX2 <= oX2 && pX2 >= oX1)) &&
        ((pX1_old <= oX2 && pX1_old >= oX1) || (pX2_old <= oX2 && pX2_old >= oX1))) {
      zeroY = true;
    } else if (player.moveY > 0 && pY2 >= oY1 && pY2_old < oY1 &&
        ((pX1 <= oX2 && pX1 >= oX1) || (pX2 <= oX2 && pX2 >= oX1)) &&
        ((pX1_old <= oX2 && pX1_old >= oX1) || (pX2_old <= oX2 && pX2_old >= oX1))) {
      zeroY = true;
    }

    if (zeroX) {
      player.setPosition(pX1_old, player.y);
      window.console.log("zero X: oX=${oX1},oY=${oY1}, pX=${pX1},pY=${pY1}");
    }
    if (zeroY) {
      player.setPosition(player.x, pY1_old);
      window.console.log("zero Y: oX=${oX1},oY=${oY1}, pX=${pX1},pY=${pY1}");
    }

    if (zeroX || zeroY) {
      //break;
    }
  }
  */

  // draw

  q.tick(null);

  drw.clear(mgr);

  q.draw(v);

  /*
  Image playerImage = player.getDrawImage();
  int playerX = player.x;
  int playerY = player.y;

  int vOffsetX = playerX + 64 - (mgr.width ~/ 2);
  int vOffsetY = playerY + 64 - (mgr.height ~/ 2);

  v.setOffset(vOffsetX, vOffsetY);

  currentRegion.drawTiles(v);


  // TODO: player must be drawn in between object layers
  v.drawImage(playerImage, playerX, playerY, 64, 64);

  currentRegion.drawObjects(v);

  */

  window.requestAnimationFrame(_loop);
}



void start(var _) {

  window.console.log('start called');

  _loop(0);

}

/*

void levelLoaded(Level l) {
  window.console.log("Level loaded");
  currentRegion = l.currentRegion;

  p.addKeyboardListener(player);

  window.console.log('loading all assets');
  //assets.load().then(start);

  start(null);
}

void gameLoaded(AssetManager _m) {

  window.console.log("gameLoaded");

  // Fetch the data
  game = _m.getJson('game').data;
  imageURIMap = _m.getJson('imageURIMap').data;

  AssetManager tileAssetsManager = new AssetManager();
  AssetManager playerAssetsManager = new AssetManager();
  AssetManager objectAssetsManager = new AssetManager();

  // Load images
  for (String imgKey in imageURIMap["tiles"].keys) {
    String uri = imageURIMap["tiles"][imgKey];
    tileAssetsManager.addImage(imgKey, uri);
  }
  for (String imgKey in imageURIMap["objects"].keys) {
    String uri = imageURIMap["objects"][imgKey];
    objectAssetsManager.addImage(imgKey, uri);
  }
  for (String imgKey in imageURIMap["player"].keys) {
    String uri = imageURIMap["player"][imgKey];
    playerAssetsManager.addImage(imgKey, uri);
  }

  // Load level file
  gameLevels = new Map<String, Level>();
  for (String levelName in game['levels']) {
    gameLevels[levelName] = null;
  }

  gameLevels[game['levels'][0]] = new Level(tileAssetsManager, objectAssetsManager, game['levels'][0]);

  tileAssetsManager.load()
    .chain((var _) => objectAssetsManager.load())
    .chain((var _) => playerAssetsManager.load())
    .then((AssetManager playerImages) {

      player = new Hero(playerImages, 640 ~/ 2 - 32, 256);
      gameLevels[game['levels'][0]].load().then(levelLoaded);
    });

}

*/


void main() {



  p = new Page();
  mgr = new CanvasManager(query('canvas'),
      width: CANVAS_WIDTH, height: CANVAS_HEIGHT, hidden: false);
  drw = mgr.drawer;
  drw.setBackground('black');

  v = new Viewport(drw,
      CANVAS_WIDTH, CANVAS_HEIGHT,
      TILE_WIDTH * 20, TILE_HEIGHT * 20,
      true);

  q = new Quest(p, start);
  q.tileWidth = TILE_WIDTH;
  q.tileHeight = TILE_HEIGHT;
  q.canvasWidth = CANVAS_WIDTH;
  q.canvasHeight = CANVAS_HEIGHT;

  q.runWhenReady();



  /*

  assets = new AssetManager();

  // Load the image uri map
  assets.addJsonData('game', 'game_data/quest/game.json');
  assets.addJsonData('imageURIMap', 'game_data/quest/image_uri_map.json');
  assets.load().then(gameLoaded);


  */
}

