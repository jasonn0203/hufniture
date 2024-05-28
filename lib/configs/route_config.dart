import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

enum PushScreenType {
  push,
  pushReplacement,
  pushAndRemoveUntil,
}

class RouteConfig {
  static Future<dynamic> navigateTo(
    BuildContext context,
    Widget screen, {
    PushScreenType pushScreenType = PushScreenType.push,
    PageTransitionType pageTransitionType = PageTransitionType.fade,
    RoutePredicate? predicate,
    Object? arguments,
  }) {
    final routeSettings = RouteSettings(arguments: arguments);
    final pageRoute = PageTransition(
        type: pageTransitionType,
        child: screen,
        settings: routeSettings,
        duration: Durations.short4,
        alignment: Alignment.center);

    switch (pushScreenType) {
      case PushScreenType.pushReplacement:
        return Navigator.pushReplacement(context, pageRoute);
      case PushScreenType.pushAndRemoveUntil:
        return Navigator.pushAndRemoveUntil(
          context,
          pageRoute,
          predicate ??
              (Route<dynamic> route) => false, // Default to removing all routes
        );
      case PushScreenType.push:
      default:
        return Navigator.push(context, pageRoute);
    }
  }
}
