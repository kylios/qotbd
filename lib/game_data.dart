library game_data;

import 'package:quest/player.dart';
import 'package:quest/assets.dart';
import 'package:quest/image_list.dart';
import 'package:quest/game_object.dart';

part 'src/game_data/hero.dart';

// objects
part 'src/game_data/objects/castle_wall_bottom_center_standard.dart';
part 'src/game_data/objects/castle_wall_top_center_standard.dart';
part 'src/game_data/objects/castle_wall_roof_center_standard.dart';

class GameData {

  final String _game_data_path = "./game_data/";

  String _game_name;

  // Data cache
  Map<String, String> _imageURIMap;

  GameData(this._game_name, AssetManager assets) {

    // Load Data files
  }
}
