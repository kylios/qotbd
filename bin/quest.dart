library quest;

import 'dart:html';

import 'package:quest/page.dart';
import 'package:quest/image.dart';
import 'package:quest/tile.dart';
import 'package:quest/asset_manager.dart';

Page p;
AssetManager assets;

void start() {

  window.console.log('start called');

  CanvasDrawer drw = p.canvasDrawer;

  Tile t = new Tile(assets.getImage('grass'));
  Tile t2 = new Tile(assets.getImage('grass_left'));
  Tile t3 = new Tile(assets.getImage('grass_right'));

  drw.drawTile(t, 40, 64, 32, 32);
  drw.drawTile(t2, 8, 64, 32, 32);
  drw.drawTile(t3, 72, 64, 32, 32);
}

void main() {

  p = new Page();
  CanvasManager mgr = p.canvasManager;
  CanvasDrawer drw = p.canvasDrawer;

  assets = new AssetManager(start);
  assets.addAsset('grass', 'img/grass.png');
  assets.addAsset('grass_left', 'img/grass_left.png');
  assets.addAsset('grass_right', 'img/grass_right.png');

  window.console.log('loading all assets');
  assets.load();


}