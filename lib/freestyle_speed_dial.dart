library freestyle_speed_dial;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef SpeedDialButtonBuilder = Widget Function(
  BuildContext context,
  SpeedDialController controller,
);

typedef SpeedDialBackdropBuilder = Widget Function(
  BuildContext context,
  SpeedDialController controller,
);

typedef SpeedDialItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
  Animation<double> animation,
  SpeedDialController controller,
);

/// This widget can be used to create speed dial buttons of all kinds of styles.
///
/// The most Basic example of a typically vertical expanding speed dial button looks like this:
///
/// ```dart
/// SpeedDialBuilder(
///   buttonBuilder: (context, controller) => FloatingActionButton(
///     onPressed: controller.toggle,
///     child: const Icon( Icons.check ),
///   ),
///   buttonAnchor: Alignment.topCenter,
///   itemAnchor: Alignment.bottomCenter,
///   itemBuilder: (context, Widget item, i, animation, controller) => FractionalTranslation(
///     translation: Offset(0, -i.toDouble()),
///     child: ScaleTransition(
///       scale: animation,
///       child: item,
///     ),
///   ),
///   items: [
///     FloatingActionButton.small(
///       onPressed: () {},
///       child: const Icon(Icons.hub),
///     ),
///     ...
///   ],
/// );
/// ```
///
/// Checkout the example or readme of the project for further details and more advanced examples.

class SpeedDialBuilder<T> extends StatefulWidget {
  /// The main button builder. This will typically return a [FloatingActionButton].
  /// However any widget with an intrinsic size might be returned here.
  ///
  /// When implementing this you can pass the `controller.toggle` function to your `onPressed` callback.
  ///
  /// To style the main button according to the state either use an [AnimatedBuilder] consuming the `controller` to react to `status` changes,
  /// or use the main animation via `controller.animation` and pass it (or a derivative of it) to a transition widget, [AnimatedBuilder], or [ValueListenableBuilder].
  ///
  /// Example of a rotating plus symbol:
  /// ```dart
  /// buttonBuilder: (context, controller) => FloatingActionButton(
  ///   onPressed: controller.toggle,
  ///   child: RotationTransition(
  ///     turns: Tween(begin: 0.0, end: 0.125).animate(CurvedAnimation(
  ///       parent: controller.animation,
  ///       curve: Curves.easeInOutCubicEmphasized,
  ///       reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
  ///     )),
  ///     child: const Icon( Icons.add ),
  ///   ),
  /// );
  /// ```
  final SpeedDialButtonBuilder buttonBuilder;

  /// The builder for the speed dial items. This will typically return a small [FloatingActionButton].
  /// However any widget with an intrinsic size might be returned here.
  ///
  /// This builder will be called for every item defined in [items].
  ///
  /// Pass the [Animation] object (or a derivative of it) to one or a combination of multiple
  /// Flutters predefined [transition classes](https://docs.flutter.dev/development/ui/widgets/animation).
  final SpeedDialItemBuilder<T> itemBuilder;

  /// An optional secondary speed dial item builder.
  /// This can be used to build an additional widget per item like a label.
  ///
  /// This builder will be called for every item defined in [items].
  ///
  /// The easiest way to properly align the labels to the main items is by wrapping the main items in a [CompositedTransformTarget]
  /// and the labels in a [CompositedTransformFollower] with their respective [LayerLink].
  ///
  /// Pass the [Animation] object (or a derivative of it) to one or a combination of multiple
  /// Flutters predefined [transition classes](https://docs.flutter.dev/development/ui/widgets/animation).
  final SpeedDialItemBuilder<T>? secondaryItemBuilder;

  /// An optional backdrop builder. Any widget with an infinite size might be returned here, like:
  /// ```dart
  /// SizedBox.expand(
  ///   child: ColoredBox(color: Colors.red),
  /// ),
  /// ```
  ///
  /// When implementing this you can pass the `controller.close` function to your backdrop widget's gesture detector.
  ///
  /// To animate the backdrop in and out either use an [AnimatedBuilder] consuming the `controller` to react to `status` changes,
  /// or use the main animation via `controller.animation` and pass it (or a derivative of it) to a transition widget, [AnimatedBuilder], or [ValueListenableBuilder].
  ///
  /// Example using the existing model barrier widget:
  ///
  /// ```dart
  /// backdropBuilder: (context, controller) => AnimatedModalBarrier(
  ///   onDismiss: controller.close,
  ///   color: ColorTween(end: Colors.red).animate(controller.animation),
  /// ),
  /// ```
  final SpeedDialBackdropBuilder? backdropBuilder;

  /// A list of items used by the [itemBuilder] and [secondaryItemBuilder].
  ///
  /// For speed dials without labels you might directly pass the sub-buttons as widgets here.
  ///
  /// If you want to show labels using the [secondaryItemBuilder] then either pass the necessary data
  /// with a [Record](https://dart.dev/language/records), a custom class, or [Map]s.
  final List<T> items;

  /// An optional controller to listen to and control the state of the speed dial.
  final SpeedDialController? controller;

  /// Define if the animation should start with the first or last item from the list.
  ///
  /// Note: This will **not** affect the order of the items.
  final bool reverse;

  /// The incoming animation duration of a single item.
  final Duration duration;

  /// The outgoing animation duration of a single item.
  final Duration reverseDuration;

  /// Defines the curve of the incoming animation of each item.
  /// Setting this to linear allows you to specify different curves for every single item later.
  final Curve curve;

  /// Defines the curve of the outgoing animation of each item.
  /// Setting this to linear allows you to specify different curves for every single item later.
  final Curve reverseCurve;

  /// A number from `0` to `1` defining the overlap ratio of the item animations.
  ///
  /// On `0` all items be animated successively while on `1` all items be animated simultaneously.'
  final double animationOverlap;

  /// Specify the anchor point of the main button to which the items should be aligned to.
  final Alignment buttonAnchor;

  /// Specify the anchor point of the items that will be snapped to the anchor point of the main button.
  final Alignment itemAnchor;

  /// A custom offset applied to each item.
  final Offset offset;

  const SpeedDialBuilder({
    required this.buttonBuilder,
    required this.itemBuilder,
    required this.items,
    this.controller,
    this.backdropBuilder,
    this.secondaryItemBuilder,
    this.buttonAnchor = Alignment.topCenter,
    this.itemAnchor = Alignment.topCenter,
    this.offset = Offset.zero,
    this.animationOverlap = 0.8,
    this.reverse = false,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutBack,
    this.reverseCurve = Curves.easeOutBack,
    Key? key,
  })  : assert(
          animationOverlap >= 0 && animationOverlap <= 1,
          'The value of the `animationOverlap` property should lie between 0 (successive animation) and 1 (simultaneous animation).',
        ),
        super(key: key);

  @override
  State createState() => _SpeedDialBuilderState<T>();
}

class _SpeedDialBuilderState<T> extends State<SpeedDialBuilder<T>>
    with SingleTickerProviderStateMixin {
  late double _intervalLength, _intervalOffset;

  late SpeedDialController _controller;

  final _buttonLayerLink = LayerLink();

  final _overlayPortalController = OverlayPortalController();

  late final _animationController = AnimationController(vsync: this);

  @override
  void initState() {
    super.initState();
    _setupController();
    _calcAnimationValues();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      // if no controller was passed dispose internally created controller
      _cleanupController(oldWidget);
      _setupController();
    }

    _calcAnimationValues();
  }

  void _setupController() {
    _controller = widget.controller ?? SpeedDialController();
    _controller._attach(_animationController, _overlayPortalController);
  }

  void _cleanupController(SpeedDialBuilder<T> widget) {
    // if no controller was passed dispose internally created controller
    if (widget.controller == null) {
      _controller.dispose();
    }
    else {
      _controller._detach();
    }
  }

  // pre calculate necessary variables
  void _calcAnimationValues() {
    // calculate animation scale factor based on overlap value and number of entries
    final animationLengthScale =
        1 + ((1 - widget.animationOverlap) * (widget.items.length - 1));

    // the length of one sub interval in a total interval from 0 to 1
    _intervalLength = 1 / animationLengthScale;

    // the length of one overlap in a sub interval
    final overlapLength = _intervalLength * widget.animationOverlap;

    // the non-overlapping length of one sub interval
    _intervalOffset = _intervalLength - overlapLength;

    // stretch length by amount of items minus the animation overlap
    _animationController.duration = widget.duration * animationLengthScale;
    _animationController.reverseDuration = widget.reverseDuration * animationLengthScale;
  }

  Widget _overlayEntryBuilder(BuildContext context) {
    return Stack(
      children: [
        if (widget.backdropBuilder != null)
          widget.backdropBuilder!(context, _controller),
        // align every item to the main button
        ...Iterable.generate(
          widget.items.length,
          (i) => CompositedTransformFollower(
            link: _buttonLayerLink,
            targetAnchor: widget.buttonAnchor,
            followerAnchor: widget.itemAnchor,
            offset: widget.offset,
            child: widget.itemBuilder(
              context,
              widget.items[i],
              i,
              _getAnimation(i),
              _controller,
            ),
          ),
        ),
        // add secondary items to stack/overlay if a builder is defined
        // this also aligns every item to the main button for consistency
        if (widget.secondaryItemBuilder != null)
          ...Iterable.generate(
            widget.items.length,
            (i) => CompositedTransformFollower(
              link: _buttonLayerLink,
              targetAnchor: widget.buttonAnchor,
              followerAnchor: widget.itemAnchor,
              offset: widget.offset,
              child: widget.secondaryItemBuilder!(
                context,
                widget.items[i],
                i,
                _getAnimation(i),
                _controller,
              ),
            ),
          ),
      ],
    );
  }

  CurvedAnimation _getAnimation(int index) {
    index = widget.reverse ? widget.items.length - index - 1 : index;

    final start = index * _intervalOffset;
    // clamp required in order to prevent <=1 assertion error caused by arithmetic imprecisions
    final end = clampDouble(start + _intervalLength, 0, 1);

    return CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        start,
        end,
        curve: widget.curve,
      ),
      reverseCurve: Interval(
        start,
        end,
        curve: widget.reverseCurve,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayPortalController,
      overlayChildBuilder: _overlayEntryBuilder,
      child: CompositedTransformTarget(
        link: _buttonLayerLink,
        child: widget.buttonBuilder(context, _controller),
      ),
    );
  }

  @override
  void dispose() {
    _cleanupController(widget);
    _animationController.dispose();
    super.dispose();
  }
}

/// Can be used to control the state of the speed dial via `open()`, `close()` and `toggle()` functions.
///
/// This is a [ChangeNotifier] that can be listened to that fires whenever the
/// [status] of the speed dial changes.
///
/// Remember to dispose the controller when no longer needed.

class SpeedDialController extends ChangeNotifier {

  AnimationController? _animationController;

  OverlayPortalController? _overlayPortalController;

  /// Main animation that drives the individual speed dial item animations.
  ///
  /// Can be used in the main button or backdrop builder to animate them with
  /// the same rate the entire speed dial animates.

  Animation<double> get animation {
    assert(isAttached, 'SpeedDialController $this is not attached to a widget yet.');
    return _animationController!;
  }

  /// State of the speed dial.
  ///
  /// Changes to this will trigger any listener callbacks.

  SpeedDialStatus get status {
    if (isAttached) {
      switch (_animationController!.status) {
        case AnimationStatus.completed: return SpeedDialStatus.opened;
        case AnimationStatus.forward: return SpeedDialStatus.opening;
        case AnimationStatus.reverse: return SpeedDialStatus.closing;
        case AnimationStatus.dismissed: return SpeedDialStatus.closed;
      }
    }
    return SpeedDialStatus.closed;
  }

  /// Whether the speed dial is opened or currently opening.
  ///
  /// This is essentially a short form of [status].

  bool get isActive => status == SpeedDialStatus.opened || status == SpeedDialStatus.opening;

  /// Whether the controller is attached to a speed dial or not.

  bool get isAttached => _animationController != null && _overlayPortalController != null;

  /// Open/Close the speed dial.

  void toggle() {
    if (isAttached) {
      if (_animationController!.status == AnimationStatus.dismissed || _animationController!.status == AnimationStatus.reverse) {
        open();
      } else {
        close();
      }
    }
  }

  /// Open the speed dial.

  void open() {
    if (isAttached && (_animationController!.status == AnimationStatus.dismissed || _animationController!.status == AnimationStatus.reverse)) {
      _overlayPortalController!.show();
      _animationController!.forward();
    }
  }

  /// Close the speed dial.

  void close() {
    if (isAttached && (_animationController!.status == AnimationStatus.completed || _animationController!.status == AnimationStatus.forward)) {
      _animationController!.reverse().then((_) {
        if (isAttached) _overlayPortalController!.hide();
      });
    }
  }

  void _attach(AnimationController animationController, OverlayPortalController overlayPortalController) {
    _animationController?.removeStatusListener(_notifyListeners);
    _animationController = animationController..addStatusListener(_notifyListeners);
    _overlayPortalController = overlayPortalController;
    // notify due to status/animation changes
    notifyListeners();
  }

  void _detach() {
    _animationController?.removeStatusListener(_notifyListeners);
    _animationController = null;
    _overlayPortalController = null;
    // notify due to status/animation changes
    notifyListeners();
  }

  void _notifyListeners(AnimationStatus status) => notifyListeners();

  @override
  void dispose() {
    _detach();
    super.dispose();
  }
}


/// The status of the [SpeedDialBuilder].

enum SpeedDialStatus {
  /// The [SpeedDialBuilder] items are completely visible.
  opened,

  /// The [SpeedDialBuilder] items are in the progress of becoming visible.
  opening,

  /// The [SpeedDialBuilder] items are in the progress of becoming hidden.
  closing,

  /// The [SpeedDialBuilder] items are completely hidden.
  closed,
}
