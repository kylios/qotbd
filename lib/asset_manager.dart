library asset_manager;

import 'dart:html';
import 'package:quest/image.dart';

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

  // True once the initial load has finished
  bool _initialLoad = false;

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

    if (this._initialLoad) {

      this._pendingLoads++;
      this._images[imgKey] = new Image(uri, this._imageLoadCallback);

    } else {

      _LoadRequest r = new _LoadRequest(imgKey, uri);
      this._loadQueue.add(r);
      this._pendingLoads++;
    }
  }

  void load() {

    if (this._loading) {
      return;
    }

    this._loading = true;
    while (this._loadQueue.length > 0) {

      // process load request
      _LoadRequest r = this._loadQueue.removeLast();
      window.console.log("loading asset ${r.imgKey}");
      if (this._images[r.imgKey] == null) {
        this._images[r.imgKey] = new Image(r.uri, this._imageLoadCallback);
      }
    }
  }

  void _imageLoadCallback(var _) {

    window.console.log('imageLoadCallback');
    this._pendingLoads--;
    if (this._pendingLoads == 0 && this._loading) {
      this._loading = false;
      this._initialLoad = true;

      // Invoke callback
      if (this._loadedCallback != null) {
        this._loadedCallback();
      }
    }
  }

  Image getImage(String imgKey) => this._images[imgKey];

}
