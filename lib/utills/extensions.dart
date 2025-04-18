import 'package:flutter/material.dart';

extension DismisskeyBoard on BuildContext {
  void dismissKeyBoard(){
    FocusScope.of(this).unfocus();
  }
}
extension KeyboardVisibility on BuildContext {
  bool get isKeyboardVisible {
    return MediaQuery.of(this).viewInsets.bottom > 0;
  }
}