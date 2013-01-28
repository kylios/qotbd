part of assets;

class SpriteManager {

  Map<String, SpriteSheet> _sprites;

  SpriteManager() {

    this._sprites = new Map<String, SpriteSheet>();
  }

  void loadJson(AssetManager spriteAssets, Map<String, Map> json) {

    for (String sKey in json.keys) {
      this._sprites[sKey] =
          new SpriteSheet.fromJson(spriteAssets, json[sKey]);
    }
  }

  SpriteSheet getSpriteSheet(String name) {
    return this._sprites[name];
  }
}
