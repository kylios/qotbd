part of quest;


class Quest {

  // The short name of this game.
  String _shortName = "quest";

  // The full name of this game
  String _name = "Sample Quest";


  Map<String, Level> gameLevels;
  Level _currentLevel;
  Region _currentRegion;
  Player _player;

  QuestData _data;

  var _runMethod = null;

  Quest(this._runMethod) {

    this._data = new QuestData.loadGame(this._shortName);
    this._data.onLoad(this._initGame);
  }

  void _initGame(QuestData _data) {

    List<String> levels = _data.levelNames;

    // Load level file
    gameLevels = new Map<String, Level>();
    for (String levelName in levels) {
      gameLevels[levelName] = null;
    }

    // Load just the first one
    // TODO: have a 'starting_level' key and load that one instead
    _data.loadLevel(levels[0])
      .then((Level l) => gameLevels[levels[0]] = l);
  }

  void run() {
    if (this._runMethod != null) {
      this._runMethod(this);
    }
  }
}