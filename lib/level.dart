library level;

import 'dart:html';
import 'dart:json';

import 'package:quest/tile.dart';
import 'package:quest/game_object.dart';
import 'package:quest/assets.dart';
import 'package:quest/game_data.dart';
import 'package:quest/viewport.dart';

part 'src/level/region.dart';
part 'src/level/editable_region.dart';

class Level {

  String _name;
  String _uri;
  AssetManager _assets;
  AssetManager _tileImages;
  AssetManager _objectImages;
  Map<String, Region> _regions;

  Region _currentRegion;

  Completer<Level> _loadCompleter = null;

  Level(this._tileImages, this._objectImages, this._name) {

    window.console.log("constructing a new level, lol");

    String levelKey = 'level_${this._name}';
    String uri = 'game_data/quest/levels/${this._name}/level.json';

    this._regions = new Map<String, Region>();
    this._assets = new AssetManager();
    this._assets.addJsonData(levelKey, uri);

  }

  Region get currentRegion => this._currentRegion;

  Future<Level> load() {

    Completer loadCompleter = new Completer<Level>();

    this._assets.load()
      .chain(this._assetLoadCallback)
      .chain(this._loadCompleteCallback)  // actually completes right away
      .then((AssetManager _m) {
        loadCompleter.complete(this);
      });

    return loadCompleter.future;
  }

  Future<AssetManager> _assetLoadCallback(AssetManager _m) {

    window.console.log("_assetsLoadCallback");

    String levelKey = 'level_${this._name}';
    Map levelData = _m.getJson(levelKey).data;

    String startingRegion = levelData['starting_region'];
    List<String> regions = levelData['regions'];

    for (String rKey in regions) {
      this._regions[rKey] =
        new Region(this._name, rKey, _m, this._tileImages, this._objectImages);
    }

    this._currentRegion = this._regions[startingRegion];

    return _m.load();
  }

  Future<AssetManager> _loadCompleteCallback(AssetManager _m) {

    Completer<AssetManager> completer = new Completer<AssetManager>();

    window.console.log("_loadCompleteCallback");

    // Pass the data back into the region objects
    for (String rKey in this._regions.keys) {
      this._regions[rKey]
        .onLoad(_m.getJson(rKey));
    }

    completer.complete(_m);

    return completer.future;
  }
}
