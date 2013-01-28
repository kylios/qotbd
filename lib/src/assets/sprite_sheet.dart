part of assets;

class SpriteSheet {

  Image _image;

  int _width;
  int _height;

  Map<String, SpriteAnimation> _animations;
  Map<String, Sprite> _sprites;

  SpriteSheet.fromJson(AssetManager images, Map json) {

    this._animations = new Map<String, SpriteAnimation>();
    this._sprites = new Map<String, Sprite>();

    this._image = images.getImage(json['image']);
    this._width = json['width'].toInt();
    this._height = json['height'].toInt();

    if (json['animations'] != null) {
      for (String key in json['animations'].keys) {
        this._animations[key] =
            new SpriteAnimation.fromJson(json['animations'][key]);
      }
    }
    if (json['sprites'] != null) {
      for (String key in json['sprites'].keys) {
        List<int> sData = json['sprites'][key];
        this._sprites[key] = new Sprite(this._image,
            sData[0], sData[1], sData[2], sData[3]);
      }
    }
  }

  Image get image => this._image;

  SpriteAnimation getAnimation(String name) => this._animations[name];
}
