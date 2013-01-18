part of assets;

class _LoadRequest {

  String _imgKey;
  String _uri;

  _LoadRequest(this._imgKey, this._uri);

  String get imgKey => this._imgKey;
  String get uri => this._uri;
}

class AssetManager {

  // True if we are actively loading assets
  bool _loading = false;

  // How many assets have actually loaded
  int _pendingLoads = 0;

  // Handle assets to be loaded
  List<_LoadRequest> _loadQueue;
  Map<String, Image> _images;
  Map<String, JsonData> _json;

  // Called when _loading is true and the _loadQueue is empty
  var _loadedCallback = null;

  Completer<AssetManager> _loadCompleter = null;

  AssetManager() {
    this._images = new Map<String, Image>();
    this._json = new Map<String, JsonData>();
    this._loadQueue = new List<_LoadRequest>();
  }

  void addImage(String imgKey, String uri) {

    this._pendingLoads++;
    this._images[imgKey] = new Image(uri, imgKey, this._loadCallback);
  }

  void addJsonData(String jsonKey, String uri) {

    this._pendingLoads++;
    this._json[jsonKey] = new JsonData(uri, this._loadCallback);
  }

  Future<AssetManager> load() {

    if (this._loading == true) {
      return this._loadCompleter.future;
    } else {
      this._loadCompleter = null;
      this._loadCompleter = new Completer();
    }

    this._loading = true;
    if (this._pendingLoads == 0) {
      this._loading = false;
      this._loadCompleter.complete(this);
      return this._loadCompleter.future;
    } else {
      return this._loadCompleter.future;
    }
  }

  void _loadCallback(var _) {

    this._pendingLoads--;
    if (this._pendingLoads == 0 && this._loading) {
      this._loading = false;

      if (this._loadCompleter != null) {
        this._loadCompleter.complete(this);
      }
    }
  }

  Image getImage(String imgKey) => this._images[imgKey];
  JsonData getJson(String jsonKey) => this._json[jsonKey];

}
