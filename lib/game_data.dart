library game_data;

import 'package:quest/player.dart';
import 'package:quest/assets.dart';
import 'package:quest/image_list.dart';
import 'package:quest/game_object.dart';

part 'src/game_data/hero.dart';


class GameData {

  String _game_name;

  // Data cache
  Map<String, String> _imageURIMap;

  GameData(this._game_name, AssetManager assets) {

    // Load Data files
  }
}
