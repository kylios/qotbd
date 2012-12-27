library quest;

import 'dart:html';

import 'package:quest/page.dart';
import 'package:quest/assets.dart';
import 'package:quest/tile.dart';
import 'package:quest/player.dart';
import 'package:quest/image_list.dart';
import 'package:quest/game_data.dart';
import 'package:quest/viewport.dart';

Page p;
AssetManager assets;
Viewport v;
Hero player;

Map<String, String> imageURIMap = {
  'p_up1': 'img/player/up1.png',
  'p_up2': 'img/player/up2.png',
  'p_up3': 'img/player/up3.png',
  'p_up4': 'img/player/up4.png',
  'p_up5': 'img/player/up5.png',
  'p_up6': 'img/player/up6.png',
  'p_up7': 'img/player/up7.png',
  'p_up8': 'img/player/up8.png',
  'p_up9': 'img/player/up9.png',
  'p_down1': 'img/player/down1.png',
  'p_down2': 'img/player/down2.png',
  'p_down3': 'img/player/down3.png',
  'p_down4': 'img/player/down4.png',
  'p_down5': 'img/player/down5.png',
  'p_down6': 'img/player/down6.png',
  'p_down7': 'img/player/down7.png',
  'p_down8': 'img/player/down8.png',
  'p_down9': 'img/player/down9.png',
  'p_left1': 'img/player/left1.png',
  'p_left2': 'img/player/left2.png',
  'p_left3': 'img/player/left3.png',
  'p_left4': 'img/player/left4.png',
  'p_left5': 'img/player/left5.png',
  'p_left6': 'img/player/left6.png',
  'p_left7': 'img/player/left7.png',
  'p_left8': 'img/player/left8.png',
  'p_left9': 'img/player/left9.png',
  'p_right1': 'img/player/right1.png',
  'p_right2': 'img/player/right2.png',
  'p_right3': 'img/player/right3.png',
  'p_right4': 'img/player/right4.png',
  'p_right5': 'img/player/right5.png',
  'p_right6': 'img/player/right6.png',
  'p_right7': 'img/player/right7.png',
  'p_right8': 'img/player/right8.png',
  'p_right9': 'img/player/right9.png',
  'cfstl': 'img/castle_floor_top_left.png',
  'cfstr': 'img/castle_floor_top_right.png',
  'cfstc': 'img/castle_floor_top_center.png',
  'cfscl': 'img/castle_floor_center_left.png',
  'cfscr': 'img/castle_floor_center_right.png',
  'cfscc': 'img/castle_floor_center_center.png',
  'cfsbl': 'img/castle_floor_bottom_left.png',
  'cfsbr': 'img/castle_floor_bottom_right.png',
  'cfsbc': 'img/castle_floor_bottom_center.png',
  'cfdbl': 'img/castle_floor_dot_bottom_left.png',
  'cfdbr': 'img/castle_floor_dot_bottom_right.png',
  'cfdtl': 'img/castle_floor_dot_top_left.png',
  'cfdtr': 'img/castle_floor_dot_top_right.png'
};

List<List<String>> level =
[
  ['cfstl', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstc', 'cfstr'],
  ['cfscl', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfscr'],
  ['cfscl', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfscr'],
  ['cfscl', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfscr'],
  ['cfscl', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfscr'],
  ['cfscl', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfscr'],
  ['cfscl', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfscr'],
  ['cfscl', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfscr'],
  ['cfscl', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfscr'],
  ['cfscl', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfscr'],
  ['cfscl', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfscr'],
  ['cfscl', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfscr'],
  ['cfscl', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfscr'],
  ['cfscl', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfscr'],
  ['cfscl', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfscr'],
  ['cfscl', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfscr'],
  ['cfscl', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfscr'],
  ['cfscl', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfdtl', 'cfdtr', 'cfscr'],
  ['cfscl', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfdbl', 'cfdbr', 'cfscr'],
  ['cfsbl', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbc', 'cfsbr']
];


double fpsAverage = 0.0;
num _renderTime = null;

void _loop(num _) {

  num time = new Date.now().millisecondsSinceEpoch;

  if (_renderTime != null) {
    //showFps((1000 / (time - this._renderTime)).round());
  }

  _renderTime = time;

  player.tick();

  // draw
  CanvasDrawer drw = p.canvasDrawer;
  CanvasManager mgr = p.canvasManager;

  drw.clear(mgr);

  int row = 0;
  int col = 0;
  for (List<String> levelRow in level) {
    col = 0;
    for (String imgKey in levelRow) {
      Tile t = new Tile(assets.getImage(imgKey));
      v.drawImage(t.image, 64 * col, 64 * row, 64, 64);
      col++;
    }
    row++;
  }

  Image playerImage = player.getDrawImage();
  int playerX = player.x;
  int playerY = player.y;

  int vOffsetX = playerX + 64 - (mgr.width ~/ 2);
  int vOffsetY = playerY + 64 - (mgr.height ~/ 2);

  v.setOffset(vOffsetX, vOffsetY);

  v.drawImage(playerImage, playerX, playerY, 64, 64);

  window.requestAnimationFrame(_loop);
}


void start() {

  window.console.log('start called');

  _loop(0);

}

void main() {

  p = new Page();
  CanvasManager mgr = p.canvasManager;
  CanvasDrawer drw = p.canvasDrawer;

  drw.setBackground('black');

  v = new Viewport(drw, 640, 480, 64 * 20, 64 * 20, true);

  assets = new AssetManager(start);

  for (String imgKey in imageURIMap.keys) {
    String uri = imageURIMap[imgKey];
    assets.addAsset(imgKey, uri);
  }



  player = new Hero(assets);

  p.addKeyboardListener(player);
  window.console.log('loading all assets');
  assets.load();


}