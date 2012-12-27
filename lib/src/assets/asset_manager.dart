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

  // Called when _loading is true and the _loadQueue is empty
  var _loadedCallback = null;

  AssetManager([this._loadedCallback = null]) {
    this._images = new Map<String, Image>();
    this._loadQueue = new List<_LoadRequest>();
  }

  void setLoadCallback(var loadedCallback) {
    this._loadedCallback = loadedCallback;
  }

  void addAsset(String imgKey, String uri) {

    this._pendingLoads++;
    this._images[imgKey] = new Image(uri, this._imageLoadCallback);
  }

  void load() {

    this._loading = true;
    if (this._pendingLoads == 0) {
      this._loading = false;
      if (this._loadedCallback != null) {
        this._loadedCallback();
      }
    }
  }

  void _imageLoadCallback(Image i) {

    window.console.log("imageLoadCallback: ${i.img.src}");
    this._pendingLoads--;
    if (this._pendingLoads == 0 && this._loading) {
      this._loading = false;

      // Invoke callback
      if (this._loadedCallback != null) {
        this._loadedCallback();
      }
    }
  }

  Image getImage(String imgKey) => this._images[imgKey];

}
