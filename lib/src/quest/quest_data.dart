part of quest;

class QuestData {

  // Indicates when this game data has been loaded
  bool _loaded = false;

  // Classes to manage the loading and retrieval of DLC
  AssetManager _dataFetcher;
  AssetManager _tiles;
  AssetManager _objects;
  AssetManager _player;

  String _gameName;

  List _loadCallbacks;

  factory QuestData.loadGame(String gameName) {

    QuestData gameData = new QuestData(gameName);

    AssetManager dataFetcher = new AssetManager();
    dataFetcher.addJsonData('game', 'game_data/${gameName}/game.json');
    dataFetcher.addJsonData('imageURIMap', 'game_data/${gameName}/image_uri_map.json');
    dataFetcher.load().then((AssetManager _m) {


      // Fetch data we just loaded
      Map<String, Map<String, String>> imageURIMap =
          _m.getJson('imageURIMap').data;

      AssetManager tileAssetsManager = new AssetManager();
      AssetManager playerAssetsManager = new AssetManager();
      AssetManager objectAssetsManager = new AssetManager();

      // Prep image files for loading
      QuestData.loadImages(imageURIMap,
          tileAssetsManager, objectAssetsManager, playerAssetsManager);

      // Wait for all the requested images to load
      tileAssetsManager.load()
      .chain((var _) => objectAssetsManager.load())
      .chain((var _) => playerAssetsManager.load())
      .then((AssetManager playerImages) {

        gameData._dataFetcher = dataFetcher;
        gameData._tiles = tileAssetsManager;
        gameData._objects = objectAssetsManager;
        gameData._player = playerAssetsManager;
        gameData.load();
      });
    });

    return gameData;
  }

  static void loadImages(Map<String, Map<String, String>> imageURIMap,
                         AssetManager tiles,
                         AssetManager objects,
                         AssetManager player) {

    if (imageURIMap['tiles'] != null) {
      for (String imgKey in imageURIMap["tiles"].keys) {
        String uri = imageURIMap["tiles"][imgKey];
        tiles.addImage(imgKey, uri);
      }
    }
    if (imageURIMap['objects'] != null) {
      for (String imgKey in imageURIMap["objects"].keys) {
        String uri = imageURIMap["objects"][imgKey];
        objects.addImage(imgKey, uri);
      }
    }
    if (imageURIMap['player'] != null) {
      for (String imgKey in imageURIMap["player"].keys) {
        String uri = imageURIMap["player"][imgKey];
        player.addImage(imgKey, uri);
      }
    }
  }

  QuestData(this._gameName) {
    this._loadCallbacks = new List();
  }

  void load() {
    this._loaded = true;
    for (var cb in this._loadCallbacks) {
      if (cb != null) {
        cb(this);
      }
    }
    this._loadCallbacks.clear();
  }

  /**
   * Schedule a function to run once this data has fully loaded.
   */
  void onLoad(var cb) {

    if (this._loaded) {
      cb(this);
    } else {
      this._loadCallbacks.add(cb);
    }
  }

  List<String> get levelNames {
    Map game = this._dataFetcher.getJson("game").data;
    return game["levels"];
  }

  Future<Level> loadLevel(String levelName) {

    Completer<Level> levelLoadCompleter = new Completer<Level>();

    if (! this.levelNames.contains(levelName)) {
      levelLoadCompleter.complete(null);
      return levelLoadCompleter.future;
    }

    // Components of the level that we need to download
    String levelKey = 'level_${levelName}';
    String uri = 'game_data/quest/levels/${levelName}/level.json';
    this._dataFetcher.addJsonData(levelKey, uri);
    this._dataFetcher.load().chain((AssetManager _m) {

      Map levelData = _m.getJson(levelKey).data;
      List<String> regions = levelData['regions'];
      Map<String, Map<String, String>> imageURIMap = levelData['image_uri_map'];

      // Fetch the images
      QuestData.loadImages(imageURIMap,
          this._tiles, this._objects, this._player);

      // Load each of the regions
      for (String r in regions) {

        String regionURI =
          'game_data/${this._gameName}/levels/${levelName}/regions/${r}.json';
        _m.addJsonData("region_${r}", regionURI);
      }

      return _m.load();
    })
    // Grab the necessary images
    .chain((var _) => this._tiles.load())
    .chain((var _) => this._objects.load())
    .chain((var _) => this._player.load())
    // Once everything's been loaded, bundle it all
    // up and pass it off to the level class
    .then((var _) {
      Level l = new Level(this._tiles, this._objects, levelName);

      Map serverData = this._dataFetcher.getJson(levelKey).data;

      // Package everything up in a nice format that the Level class recognizes
      // TODO: should the Level class handle this somehow?
      String realName = serverData['name'];
      String startingRegion = serverData['starting_region'];
      List<String> regionList = serverData['regions'];
      Map<String, Map> regions = new Map<String, Map>();

      for (String r in regionList) {

        Map regionData = this._dataFetcher.getJson("region_${r}").data;
        if (regionData != null) {
          regions[r] = regionData;
        }
      }

      Map packagedData = new Map();
      packagedData['real_name'] = realName;
      packagedData['starting_region'] = startingRegion;
      packagedData['regions'] = regions;

      // Load the package into the new level object.  If the Level imports
      // the data successfully, signal back to the game that we're all done.
      if (l.fromData(packagedData)) {
        levelLoadCompleter.complete(l);
      } else {
        levelLoadCompleter.complete(null);
      }
    });

    return levelLoadCompleter.future;
  }

}