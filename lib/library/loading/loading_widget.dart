import 'dart:async';
import 'package:flutter/material.dart';
import 'package:widget/library/theme/theme_widget.dart';
import 'back_button_interceptor.dart';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart' hide CupertinoActivityIndicator;

typedef HideCallback = Future Function();

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
    @required this.stopEvent,
    @required this.alignment,
    @required this.icon,
    @required this.message,
  }) : super(key: key);

  final bool stopEvent;
  final Alignment alignment;
  final Widget icon;
  final Widget message;

  @override
  Widget build(BuildContext context) {
    var widget = Material(
      color: Colors.transparent,
      child: Align(
        alignment: this.alignment,
        child: IntrinsicHeight(
          child: Container(
            width: 122.0,
            decoration: BoxDecoration(
                color: Color.fromRGBO(17, 17, 17, 0.7),
                borderRadius: BorderRadius.circular(5.0)),
            constraints: BoxConstraints(
              minHeight: 122.0,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 22.0),
                  constraints: BoxConstraints(minHeight: 55.0),
                  child: IconTheme(
                      data: IconThemeData(color: Colors.white, size: 55.0),
                      child: icon),
                ),
                DefaultTextStyle(
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                  child: message,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return IgnorePointer(
      ignoring: !stopEvent,
      child: widget,
    );
  }
}

Future showLoadSuccess(
    {@required BuildContext context,
      Widget message,
      stopEvent = false,
      bool backButtonClose,
      Alignment alignment,
      Duration closeDuration}) {

  var config = ThemeWidget.of(context).config;
  message = message?? Text(config.successText);
  closeDuration = closeDuration?? config.successDuration;
  backButtonClose = backButtonClose ?? config.successBackButtonClose;
  var hide = showLoadingWidget(
      context: context,
      alignment: alignment,
      message: message,
      stopEvent: stopEvent,
      backButtonClose: backButtonClose,
      icon: Icon(Icons.check,size: 36,));

  return Future.delayed(closeDuration, () {
    hide();
  });
}

HideCallback showLoading(
    {@required BuildContext context,
      Widget message,
      stopEvent = true,
      bool backButtonClose,
      Alignment alignment}) {
  var config = ThemeWidget.of(context).config;
  message = message?? Text(config.loadingText);
  backButtonClose = backButtonClose ?? config.loadingBackButtonClose;

  return showLoadingWidget(
      context: context,
      alignment: alignment,
      message: message,
      stopEvent: stopEvent,
      icon: CupertinoActivityIndicator(radius: 16,),
      backButtonClose: backButtonClose);
}

int backButtonIndex = 2;

HideCallback showLoadingWidget(
    {@required BuildContext context,
      @required Widget message,
      @required Widget icon,
      bool stopEvent = false,
      Alignment alignment,
      bool backButtonClose}) {

  var config = ThemeWidget.of(context).config;
  alignment = alignment?? config.toastAlignment;

  Completer<VoidCallback> result = Completer<VoidCallback>();
  var backButtonName = 'LoadingWidget_$backButtonIndex';
  BackButtonInterceptor.add((stopDefaultButtonEvent,info){
    print(backButtonClose);
    if(backButtonClose){
      result.future.then((hide){
        hide();
      });
    }
    return true;
  }, zIndex: backButtonIndex, name: backButtonName);
  backButtonIndex++;

  var overlay = OverlayEntry(
      maintainState: true,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          var hide = await result.future;
          hide();
          return false;
        },
        child: LoadingWidget(
          alignment: alignment,
          icon: icon,
          message: message,
          stopEvent: stopEvent,
        ),
      ));
  result.complete((){
    if(overlay == null){
      return;
    }
    overlay.remove();
    overlay = null;
    BackButtonInterceptor.removeByName(backButtonName);
  });
  Overlay.of(context).insert(overlay);


  return () async {
    var hide = await result.future;
    hide();
  };
}

const double _kDefaultIndicatorRadius = 10.0;
///修改 IOS加载指示器默认颜色
const Color _kActiveTickColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFFFFF),
  darkColor: Color(0xFFEBEBF5),
);
enum CupertinoActivityIndicatorIOSVersionStyle {
iOS14,
}
class CupertinoActivityIndicator extends StatefulWidget {
  /// Creates an iOS-style activity indicator that spins clockwise.
  const CupertinoActivityIndicator({
    Key key,
    this.animating = true,
    this.radius = _kDefaultIndicatorRadius,
    @Deprecated(
        'Leave this field default to use latest style. '
            'This feature was deprecated after v1.21.0-1.0.pre.'
    )
    this.iOSVersionStyle = CupertinoActivityIndicatorIOSVersionStyle.iOS14,
  })  : assert(animating != null),
        assert(radius != null),
        assert(radius > 0.0),
        progress = 1.0,
        super(key: key);

  /// Creates a non-animated iOS-style activity indicator that displays
  /// a partial count of ticks based on the value of [progress].
  ///
  /// When provided, the value of [progress] must be between 0.0 (zero ticks
  /// will be shown) and 1.0 (all ticks will be shown) inclusive. Defaults
  /// to 1.0.
  const CupertinoActivityIndicator.partiallyRevealed({
    Key key,
    this.radius = _kDefaultIndicatorRadius,
    this.progress = 1.0,
    @Deprecated(
        'Leave this field default to use latest style. '
            'This feature was deprecated after v1.21.0-1.0.pre.'
    )
    this.iOSVersionStyle = CupertinoActivityIndicatorIOSVersionStyle.iOS14,
  })  : assert(radius != null),
        assert(radius > 0.0),
        assert(progress != null),
        assert(progress >= 0.0),
        assert(progress <= 1.0),
        animating = false,
        super(key: key);

  /// Whether the activity indicator is running its animation.
  ///
  /// Defaults to true.
  final bool animating;

  /// Radius of the spinner widget.
  ///
  /// Defaults to 10px. Must be positive and cannot be null.
  final double radius;

  /// Determines the percentage of spinner ticks that will be shown. Typical usage would
  /// display all ticks, however, this allows for more fine-grained control such as
  /// during pull-to-refresh when the drag-down action shows one tick at a time as
  /// the user continues to drag down.
  ///
  /// Defaults to 1.0. Must be between 0.0 and 1.0 inclusive, and cannot be null.
  final double progress;

  /// The iOS version style of activity indicator.
  ///
  /// Defaults to [CupertinoActivityIndicatorIOSVersionStyle.iOS14].
  // TODO(ctrysbita): Deprecate after official release, https://github.com/flutter/flutter/issues/62521
  final CupertinoActivityIndicatorIOSVersionStyle iOSVersionStyle;

  @override
  _CupertinoActivityIndicatorState createState() =>
      _CupertinoActivityIndicatorState();
}

class _CupertinoActivityIndicatorState extends State<CupertinoActivityIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(CupertinoActivityIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating)
        _controller.repeat();
      else
        _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _CupertinoActivityIndicatorPainter(
          position: _controller,
          activeColor:
          CupertinoDynamicColor.resolve(_kActiveTickColor, context),
          radius: widget.radius,
          progress: widget.progress,
          iOSVersionStyle: widget.iOSVersionStyle,
        ),
      ),
    );
  }
}

const double _kTwoPI = math.pi * 2.0;

/// Alpha values extracted from the native component (for both dark and light mode) to
/// draw the spinning ticks.
const Map<CupertinoActivityIndicatorIOSVersionStyle, List<int>>
_kAlphaValuesMap = <CupertinoActivityIndicatorIOSVersionStyle, List<int>>{
  /// Alpha values for new style that introduced in iOS14.
  CupertinoActivityIndicatorIOSVersionStyle.iOS14: <int>[
    47,
    47,
    47,
    47,
    72,
    97,
    122,
    147,
  ],
};

/// The alpha value that is used to draw the partially revealed ticks.
const int _partiallyRevealedAlpha = 147;

class _CupertinoActivityIndicatorPainter extends CustomPainter {
  _CupertinoActivityIndicatorPainter({
    @required this.position,
    @required this.activeColor,
    @required this.radius,
    @required this.progress,
    CupertinoActivityIndicatorIOSVersionStyle iOSVersionStyle =
        CupertinoActivityIndicatorIOSVersionStyle.iOS14,
  })  : alphaValues = _kAlphaValuesMap[iOSVersionStyle],
        tickFundamentalRRect = RRect.fromLTRBXY(
          -radius / _kDefaultIndicatorRadius,
          -radius /
              (iOSVersionStyle ==
                  CupertinoActivityIndicatorIOSVersionStyle.iOS14
                  ? 3.0
                  : 2.0),
          radius / _kDefaultIndicatorRadius,
          -radius,
          radius / _kDefaultIndicatorRadius,
          radius / _kDefaultIndicatorRadius,
        ),
        super(repaint: position);

  final Animation<double> position;
  final Color activeColor;
  final double radius;
  final double progress;

  final List<int> alphaValues;
  final RRect tickFundamentalRRect;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final int tickCount = alphaValues.length;

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (tickCount * position.value).floor();

    for (int i = 0; i < tickCount * progress; ++i) {
      final int t = (i - activeTick) % tickCount;
      paint.color = activeColor
          .withAlpha(progress < 1 ? _partiallyRevealedAlpha : alphaValues[t]);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(_kTwoPI / tickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CupertinoActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position ||
        oldPainter.activeColor != activeColor ||
        oldPainter.progress != progress;
  }
}