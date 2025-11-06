import 'package:flutter/material.dart';

class NavigationHelper {
  static goToNavigatorScreen(
      BuildContext context,
      Widget widget, {
        bool? finish = false,
        bool? back = true,
      }) {
    if (finish == false) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => widget));
    } else {
      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(builder: (BuildContext context) => widget),
            (route) => back!,
      );
    }
  }

  static Future<dynamic> goToNavigatorScreenForResult(
      BuildContext context,
      Widget widget,
      ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

    return result;
  }

  static void goBackToPreviousPage(
      BuildContext context, {
        bool? useCustomAnimation,
        PageTransitionsBuilder? pageTransitionsBuilder,
        dynamic result,
      }) {
    Navigator.of(context).pop(result);
  }
}
