import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'merge_sort.dart';

abstract class BackButtonInterceptor implements WidgetsBinding {
  static final List<_FunctionWithZIndex> _interceptors = [];
  static final InterceptorResults results = InterceptorResults();

  static Function(dynamic) errorProcessing = (error) {
    print("The BackButtonInterceptor threw an ERROR: $error.");
    Future.delayed(Duration(), () => throw error);
  };

  static Function handlePopRouteFunction = WidgetsBinding.instance.handlePopRoute;

  static Function handlePushRouteFunction = WidgetsBinding.instance.handlePushRoute;

  static void add(
      InterceptorFunction interceptorFunction, {
        bool ifNotYetIntercepted = false,
        int zIndex,
        String name,
        BuildContext context,
      }) {
    _interceptors.insert(
        0,
        _FunctionWithZIndex(
          interceptorFunction,
          ifNotYetIntercepted,
          zIndex,
          name,
          context == null ? null : getCurrentNavigatorRoute(context),
        ));
    stableSort(_interceptors);
    SystemChannels.navigation.setMethodCallHandler(_handleNavigationInvocation);
  }

  /// Removes the function.
  static void remove(InterceptorFunction interceptorFunction) {
    _interceptors
        .removeWhere((interceptor) => interceptor.interceptionFunction == interceptorFunction);
  }

  /// Removes the function by name.
  static void removeByName(String name) {
    assert(name != null);
    _interceptors.removeWhere((interceptor) => interceptor.name == name);
  }

  /// Removes all functions.
  static void removeAll() {
    _interceptors.clear();
  }

  /// Trick explained here: https://github.com/flutter/flutter/issues/20451
  /// Note `ModalRoute.of(context).settings.name` doesn't always work.
  static Route getCurrentNavigatorRoute(BuildContext context) {
    Route currentRoute;
    Navigator.popUntil(context, (route) {
      currentRoute = route;
      return true;
    });
    return currentRoute;
  }

  /// Trick explained here: https://github.com/flutter/flutter/issues/20451
  /// Note `ModalRoute.of(context).settings.name` doesn't always work.
  static String getCurrentNavigatorRouteName(BuildContext context) =>
      getCurrentNavigatorRoute(context).settings.name;

  static Future<dynamic> _handleNavigationInvocation(MethodCall methodCall) async {
    // POP.
    if (methodCall.method == 'popRoute')
      return popRoute();

    // PUSH.
    else if (methodCall.method == 'pushRoute')
      return _pushRoute(methodCall.arguments);

    // OTHER.
    else
      return Future<dynamic>.value();
  }

  static Future popRoute() {
    bool stopDefaultButtonEvent = false;

    results.clear();

    List<_FunctionWithZIndex> interceptors = List.of(_interceptors);

    for (var i = 0; i < interceptors.length; i++) {
      bool result;

      try {
        var interceptor = interceptors[i];

        if (!interceptor.ifNotYetIntercepted || !stopDefaultButtonEvent) {
          result = interceptor.interceptionFunction(
            stopDefaultButtonEvent,
            RouteInfo(routeWhenAdded: interceptor.routeWhenAdded),
          );

          results.results.add(InterceptorResult(interceptor.name, result));
        }
      } catch (error) {
        errorProcessing(error);
      }

      if (result == true) stopDefaultButtonEvent = true;
    }

    if (stopDefaultButtonEvent)
      return Future<dynamic>.value();
    else {
      results.ifDefaultButtonEventWasFired = true;
      return handlePopRouteFunction();
    }
  }

  static Future<void> _pushRoute(dynamic arguments) => handlePushRouteFunction(arguments);

  /// Describes all interceptors, with their names and z-indexes.
  /// This may help you debug your interceptors, by printing them
  /// to the console, like this:
  /// `print(BackButtonInterceptor.describe());`
  static String describe() => _interceptors.join("\n");
}

typedef InterceptorFunction = bool Function(bool stopDefaultButtonEvent, RouteInfo routeInfo);

class RouteInfo {
  /// The current route when the interceptor was added
  /// through the BackButtonInterceptor.add() method.
  final Route routeWhenAdded;

  RouteInfo({this.routeWhenAdded});

  Route currentRoute(BuildContext context) =>
      BackButtonInterceptor.getCurrentNavigatorRoute(context);

  /// This method can only be called if the context parameter was
  /// passed to the BackButtonInterceptor.add() method.
  bool ifRouteChanged(BuildContext context) {
    if (routeWhenAdded == null)
      throw AssertionError("The ifRouteChanged() method "
          "can only be called if the context parameter was "
          "passed to the BackButtonInterceptor.add() method.");

    return !identical(currentRoute(context), routeWhenAdded);
  }
}

class InterceptorResult {
  String name;
  bool stopDefaultButtonEvent;

  InterceptorResult(this.name, this.stopDefaultButtonEvent);
}

class InterceptorResults {
  int count = 0;
  List<InterceptorResult> results = [];
  bool ifDefaultButtonEventWasFired = false;

  void clear() {
    results = [];
    ifDefaultButtonEventWasFired = false;
    count++;
  }

  InterceptorResult getNamed(String name) =>
      results.firstWhere((result) => result.name == name, orElse: () => null);
}

class _FunctionWithZIndex implements Comparable<_FunctionWithZIndex> {
  final InterceptorFunction interceptionFunction;
  final bool ifNotYetIntercepted;
  final int zIndex;
  final String name;
  final Route routeWhenAdded;

  _FunctionWithZIndex(
      this.interceptionFunction,
      this.ifNotYetIntercepted,
      this.zIndex,
      this.name,
      this.routeWhenAdded,
      );

  @override
  int compareTo(_FunctionWithZIndex other) {
    if (zIndex == null && other.zIndex == null)
      return 0;
    else if (zIndex == null && other.zIndex != null)
      return 1;
    else if (zIndex != null && other.zIndex == null)
      return -1;
    else
      return other.zIndex.compareTo(zIndex);
  }

  @override
  String toString() =>
      'BackButtonInterceptor: $name, z-index: $zIndex (ifNotYetIntercepted: $ifNotYetIntercepted).';
}
