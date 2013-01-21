library level;

import 'dart:html';
import 'dart:json';

import 'package:quest/quest.dart';
import 'package:quest/tile.dart';
import 'package:quest/game_object.dart';
import 'package:quest/assets.dart';
import 'package:quest/game_data.dart';
import 'package:quest/viewport.dart';

part 'src/level/region.dart';
part 'src/level/editable_region.dart';

class Level implements QuestLoadable {

  String _name;
  String _realName;

  AssetManager _tileImages;
  AssetManager _objectImages;
  Map<String, Region> _regions;

  Region _currentRegion;

  Level(this._tileImages, this._objectImages, this._name);

  Region get currentRegion => this._currentRegion;

  bool fromData(Map data) {

    String realName = data['real_name'];
    Map<String, Map> regions = data['regions'];
    String startingRegion = data['starting_region'];

    // Just make sure we're passed what we need
    if (realName == null || regions == null || startingRegion == null ||
        regions[startingRegion] == null) {
      return false;
    }

    this._realName = realName;
    this._regions = new Map<String, Region>();

    for (String r in regions.keys) {
      Region reg = new Region(this._tileImages, this._objectImages, r,
          regions[r]);
      this._regions[r] = reg;
    }

    this._currentRegion = this._regions[startingRegion];

    return true;
  }

  Map toData() {

  }
}
