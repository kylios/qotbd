part of quest;

class QuestData {

  // Indicates when this game data has been loaded
  bool _loaded = false;

  // Classes to manage the loading and retrieval of DLC
  AssetManager _dataFetcher;
  // TODO: these should go, and get replaced by SpriteManagers
  AssetManager _tiles;
  AssetManager _objects;
  AssetManager _player;
  AssetManager _spritesheets;

  SpriteManager _tileSprites;
  SpriteManager _objectSprites;
  SpriteManager _playerSprites;

  String _gameName;

  List _loadCallbacks;




  factory QuestData.loadGame(String gameName) {

    QuestData gameData = new QuestData(gameName);

    AssetManager dataFetcher = new AssetManager();
    dataFetcher.addJsonData('game', 'game_data/${gameName}/game.json');
    dataFetcher.addJsonData('imageURIMap', 'game_data/${gameName}/image_uri_map.json');
    dataFetcher.addJsonData('sprites', 'game_data/${gameName}/sprites.json');
    dataFetcher.load().then((AssetManager _m) {

      AssetManager tileAssetsManager = new AssetManager();
      AssetManager playerAssetsManager = new AssetManager();
      AssetManager objectAssetsManager = new AssetManager();
      AssetManager spriteAssetsManager = new AssetManager();

      SpriteManager tileSprites = new SpriteManager();
      SpriteManager objectSprites = new SpriteManager();
      SpriteManager playerSprites = new SpriteManager();

      // Prep image files for loading
      Map<String, Map<String, String>> imageURIMap =
          dataFetcher.getJson("imageURIMap").data;
      QuestData.loadImages(imageURIMap,
          tileAssetsManager, objectAssetsManager,
          playerAssetsManager, spriteAssetsManager);

      // Wait for all the requested images to load
      tileAssetsManager.load().chain((var _) =>
      objectAssetsManager.load()).chain((var _) =>
      playerAssetsManager.load()).chain((var _) =>
      spriteAssetsManager.load()).then((var _) {

        // Initialize the sprite sheets, now that we have all the images
        QuestData.initSprites(dataFetcher, spriteAssetsManager,
            tileSprites, objectSprites, playerSprites);

        // Assign all the things
        gameData._dataFetcher = dataFetcher;
        gameData._tiles = tileAssetsManager;
        gameData._objects = objectAssetsManager;
        gameData._player = playerAssetsManager;
        gameData._spritesheets = spriteAssetsManager;

        gameData._tileSprites = tileSprites;
        gameData._objectSprites = objectSprites;
        gameData._playerSprites = playerSprites;

        gameData.load();
      });
    });

    return gameData;
  }





  static void initSprites(AssetManager data,
                          AssetManager spriteAssets,
                          SpriteManager tiles,
                          SpriteManager objects,
                          SpriteManager player) {

    window.console.log("Loading Sprites...");
    Map<String, Map> spriteData = data.getJson("sprites").data;

    if (spriteData['tiles'] != null) {
      tiles.loadJson(spriteAssets, spriteData['tiles']);
    }
    if (spriteData['objects'] != null) {
      objects.loadJson(spriteAssets, spriteData['objects']);
    }
    if (spriteData['player'] != null) {
      player.loadJson(spriteAssets, spriteData['player']);
    }
  }






  static void loadImages(Map<String, Map<String, String>> imageURIMap,
                         AssetManager tiles,
                         AssetManager objects,
                         AssetManager player,
                         AssetManager sprites) {

    window.console.log("Loading Images...");

    if (imageURIMap['tiles'] != null) {
      for (String imgKey in imageURIMap["tiles"].keys) {
        String uri = imageURIMap["tiles"][imgKey];
        tiles.addImage(imgKey, uri);
      }
    } else window.console.log("WORNING no tiles");
    if (imageURIMap['objects'] != null) {
      for (String imgKey in imageURIMap["objects"].keys) {
        String uri = imageURIMap["objects"][imgKey];
        objects.addImage(imgKey, uri);
      }
    } else window.console.log("WORNING no objects");
    if (imageURIMap['player'] != null) {
      for (String imgKey in imageURIMap["player"].keys) {
        String uri = imageURIMap["player"][imgKey];
        player.addImage(imgKey, uri);
      }
    } else window.console.log("WORNING no player");
    if (imageURIMap['spritesheets'] != null) {
      for (String imgKey in imageURIMap["spritesheets"].keys) {
        String uri = imageURIMap["spritesheets"][imgKey];
        sprites.addImage(imgKey, uri);
        window.console.log("Adding image [${imgKey}] for ${uri}");
      }
    } else window.console.log("WORNING no spritesheets");
  }





  QuestData(this._gameName) {
    this._loadCallbacks = new List();
  }





  void load() {
    window.console.log("QuestData done loading");
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

    window.console.log("Loading Level ${levelName}");
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

      Map levelData = this._dataFetcher.getJson(levelKey).data;
      List<String> regions = levelData['regions'];
      Map<String, Map<String, String>> imageURIMap = levelData['image_uri_map'];

      // Fetch the images
      QuestData.loadImages(imageURIMap,
          this._tiles, this._objects, this._player, this._spritesheets);

      // Load each of the regions
      for (String r in regions) {
        String regionURI =
          'game_data/${this._gameName}/levels/${levelName}/regions/${r}.json';
        this._dataFetcher.addJsonData("region_${r}", regionURI);
      }

      return this._dataFetcher.load();
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