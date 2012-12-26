library region;

import 'package:quest/tile.dart';

class Region {

  int _rowLength;
  int _colLength;

  List<List<Tile>> _tiles;

  Region(this._rowLength, this._colLength);
}
