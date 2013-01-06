part of page;

abstract class InputController {

  Element _inputElement;

  InputController(this._inputElement) {

  }

  void onClick(var cb);
  void onChange(var cb);
}
