library quest;

import 'dart:html';

import 'package:quest/page.dart';
import 'package:quest/assets.dart';
import 'package:quest/tile.dart';
import 'package:quest/player.dart';
import 'package:quest/image_list.dart';
import 'package:quest/game_data.dart';
import 'package:quest/viewport.dart';
import 'package:quest/game_object.dart';
import 'package:quest/level.dart';

Page p;
AssetManager assets;
Viewport v;
Hero player;
//GameObjectManager objects;
Map game;
Level currentLevel;
Map<String, Level> gameLevels;
Region currentRegion;

Map<String, String> imageURIMap = null;

double fpsAverage = 0.0;
num _renderTime = null;

void _loop(num _) {

  num time = new Date.now().millisecondsSinceEpoch;

  if (_renderTime != null) {
    //showFps((1000 / (time - this._renderTime)).round());
  }

  _renderTime = time;

  player.tick();

  // Collision detection
  for (GameObject o in
      currentRegion.staticObjects.getNearbyBlockingObjects(player.x, player.y)
      /* objects.blockingObjects*/ ) {

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

  // draw
  CanvasDrawer drw = p.canvasDrawer;
  CanvasManager mgr = p.canvasManager;

  drw.clear(mgr);

  Image playerImage = player.getDrawImage();
  int playerX = player.x;
  int playerY = player.y;

  int vOffsetX = playerX + 64 - (mgr.width ~/ 2);
  int vOffsetY = playerY + 64 - (mgr.height ~/ 2);

  v.setOffset(vOffsetX, vOffsetY);

  int row = 0;
  int col = 0;
  for (List<String> levelRow in currentRegion.tiles) {
    col = 0;
    for (String imgKey in levelRow) {
      if (imgKey != null) {
        Tile t = new Tile(assets.getImage(imgKey));
        v.drawImage(t.image, 64 * col, 64 * row, 64, 64);
      }
      col++;
    }
    row++;
  }



  v.drawImage(playerImage, playerX, playerY, 64, 64);

  for (GameObject o in currentRegion.staticObjects /* objects */) {
    if (o != null) {
      v.drawImage(o.image, o.x, o.y, o.width, o.height);
    }
  }

  window.requestAnimationFrame(_loop);
}



void start() {

  window.console.log('start called');

  _loop(0);

}

void levelLoaded(Level l) {
  window.console.log("Level loaded");
  currentRegion = l.currentRegion;

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

  // Load level file
  gameLevels = new Map<String, Level>();
  for (String levelName in game['levels']) {
    gameLevels[levelName] = null;
  }

  gameLevels[game['levels'][0]] = new Level(assets, game['levels'][0], levelLoaded);

  player = new Hero(assets, 640 ~/ 2 - 32, 256);

  p.addKeyboardListener(player);
  window.console.log('loading all assets');
  assets.load();
}


void main() {

  p = new Page();
  p.manageCanvas(query('canvas'), 640, 480, false);
  CanvasManager mgr = p.canvasManager;
  CanvasDrawer drw = p.canvasDrawer;

  drw.setBackground('black');

  v = new Viewport(drw, 640, 480, 64 * 20, 64 * 20, true);

  assets = new AssetManager(gameLoaded);

  // Load the image uri map
  assets.addJsonData('game', 'game_data/quest/game.json');
  assets.addJsonData('imageURIMap', 'game_data/quest/image_uri_map.json');
  assets.load();

}

