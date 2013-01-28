part of quest;

class Quest {

  // The short name of this game.
  String _shortName = "quest";

  // The full name of this game
  String _name = "Sample Quest";

  Page _page;

  Map<String, Level> gameLevels;
  Level _currentLevel;
  Region _currentRegion;
  Hero _player;

  QuestData _data;

  var _runMethod = null;

  bool _ready = false;
  bool _runWhenReady = false;

  // Various parameters that should be set externally
  int tileWidth = 64;
  int tileHeight = 64;
  int canvasWidth = 640;
  int canvasHeight = 480;

  Quest(this._page, this._runMethod) {

    this._data = new QuestData.loadGame(this._shortName);
    this._data.onLoad(this._initGame);
  }

  Hero get player => this._player;

  void _initGame(QuestData _data) {

    // TODO: initial player state should come from _data
    this._player = new Hero(_data._playerSprites, 128, 0);
    this._page.addKeyboardListener(this._player);

    List<String> levels = _data.levelNames;

    // Load level file
    this.gameLevels = new Map<String, Level>();
    for (String levelName in levels) {
      this.gameLevels[levelName] = null;
    }

    // Load just the first one
    // TODO: have a 'starting_level' key and load that one instead
    _data.loadLevel(levels[0])
      .then((Level l) {
        this.gameLevels[levels[0]] = l;

        this._currentLevel = l;
        this._currentRegion = l.currentRegion;


        this._ready = true;
        if (this._runWhenReady) {
          this.runWhenReady();
        }
      });
  }

  void runWhenReady() {
    if (this._ready) {
      if (this._runMethod != null) {
        this._runMethod(this);
      }
    } else {
      this._runWhenReady = true;
    }
  }

  void tick(var _) {

    this._player.tick();

    List<GameObject> nearbyBlockingObjects =
        this._currentRegion.staticObjects.getNearbyBlockingObjects(
            this._player.x,
            this._player.y);

    // Collision detection
    for (GameObject o in nearbyBlockingObjects) {

      int oX1 = o.x;
      int oX2 = o.x + o.width;
      int oY1 = o.y;
      int oY2 = o.y + o.height;

      int pX1 = this._player.x;
      int pX2 = this._player.x + this.tileWidth;
      int pY1 = this._player.y;
      int pY2 = this._player.y + this.tileHeight;

      int pX1_old = pX1 - this._player.moveX * this._player.speed;
      int pX2_old = pX2 - this._player.moveX * this._player.speed;
      int pY1_old = pY1 - this._player.moveY * this._player.speed;
      int pY2_old = pY2 - this._player.moveY * this._player.speed;

      bool zeroX = false;
      bool zeroY = false;

      if (this._player.moveX < 0 && pX1 <= oX2 && pX1_old > oX2 &&
          ((pY1 <= oY2 && pY1 >= oY1) || (pY2 <= oY2 && pY2 >= oY1)) &&
          ((pY1_old <= oY2 && pY1_old >= oY1) || (pY2_old <= oY2 && pY2_old >= oY1))) {
        zeroX = true;
      } else if (this._player.moveX > 0 && pX2 >= oX1 && pX2_old < oX1 &&
          ((pY1 <= oY2 && pY1 >= oY1) || (pY2 <= oY2 && pY2 >= oY1)) &&
          ((pY1_old <= oY2 && pY1_old >= oY1) || (pY2_old <= oY2 && pY2_old >= oY1))) {
        zeroX = true;
      }
      if (this._player.moveY < 0 && pY1 <= oY2 && pY1_old > oY2 &&
          ((pX1 <= oX2 && pX1 >= oX1) || (pX2 <= oX2 && pX2 >= oX1)) &&
          ((pX1_old <= oX2 && pX1_old >= oX1) || (pX2_old <= oX2 && pX2_old >= oX1))) {
        zeroY = true;
      } else if (this._player.moveY > 0 && pY2 >= oY1 && pY2_old < oY1 &&
          ((pX1 <= oX2 && pX1 >= oX1) || (pX2 <= oX2 && pX2 >= oX1)) &&
          ((pX1_old <= oX2 && pX1_old >= oX1) || (pX2_old <= oX2 && pX2_old >= oX1))) {
        zeroY = true;
      }

      if (zeroX) {
        this._player.setPosition(pX1_old, this._player.y);
      }
      if (zeroY) {
        this._player.setPosition(this._player.x, pY1_old);
      }

      if (zeroX || zeroY) {
        //break;
      }
    }
  }

  void draw(Viewport v) {
    int playerX = this._player.x;
    int playerY = this._player.y;

    int vOffsetX = playerX + this.tileWidth - (this.canvasWidth ~/ 2);
    int vOffsetY = playerY + this.tileHeight - (this.canvasHeight ~/ 2);

    v.setOffset(vOffsetX, vOffsetY);

    this._currentRegion.drawTiles(v);


    // TODO: this._player must be drawn in between object layers
    Sprite playerSprite = this._player.getDrawSprite();
    v.drawSprite(playerSprite,
        playerX, playerY, this.tileWidth, this.tileHeight);

    this._currentRegion.drawObjects(v);
  }
}