import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';


void showLoader() => BotToast.showCustomLoading(
  toastBuilder: (cancelFunc) => Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
    ),
  ),
  animationDuration: Duration(milliseconds: 200),
);

void hideLoader() => BotToast.closeAllLoading();