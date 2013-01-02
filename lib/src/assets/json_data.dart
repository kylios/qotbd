part of assets;

class JsonData {

  Map _data = null;
  var _onReady = null;
  bool _ready = false;

  JsonData(String url, [var onReady]) {
    if (?onReady) {
      this._onReady = onReady;
    }

    var request = new HttpRequest.get(url, this._loadCallback);
  }

  void _loadCallback(HttpRequest r) {
    window.console.log(r.toString());
    String response = r.responseText;
    this._data = JSON.parse(response);
    this._ready = true;
    if (this._onReady != null) {
      this._onReady(this);
    }
  }

  Map get data => (this._ready ? this._data : null);
  bool get ready => this._ready;
}
