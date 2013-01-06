library level;

import 'dart:html';
import 'package:quest/tile.dart';
import 'package:quest/game_object.dart';
import 'package:quest/assets.dart';
import 'package:quest/game_data.dart';

part 'src/level/region.dart';
part 'src/level/editable_region.dart';

class Level {

  String _name;
  String _uri;
  AssetManager _assets;
  AssetManager _images;
  Map<String, Region> _regions;
  var _loadCallback;

  Region _currentRegion;

  Level(this._images, this._name, this._loadCallback) {

    String levelKey = 'level_${this._name}';
    String uri = 'game_data/quest/levels/${this._name}/level.json';

    this._regions = new Map<String, Region>();
    this._assets = new AssetManager(this._assetLoadCallback);
    this._assets.addJsonData(levelKey, uri);
    this._assets.load();
  }

  Region get currentRegion => this._currentRegion;

  void _assetLoadCallback() {

    String levelKey = 'level_${this._name}';
    Map levelData = this._assets.getJson(levelKey).data;

    String startingRegion = levelData['starting_region'];
    List<String> regions = levelData['regions'];

    this._assets.setLoadCallback(this._loadCompleteCallback);
    for (String rKey in regions) {
      this._regions[rKey] =
          new Region(this._name, rKey, this._assets);
    }
    this._assets.load();

    this._currentRegion = this._regions[startingRegion];
  }

  void _loadCompleteCallback() {

    // Pass the data back into the region objects
    for (String rKey in this._regions.keys) {
      this._regions[rKey].onLoad(this._assets.getJson(rKey), this._images);
    }

    this._loadCallback(this);
  }
}
