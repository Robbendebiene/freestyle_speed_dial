library freestyle_speed_dial;

import 'package:flutter/material.dart';


typedef SpeedDialButtonBuilder = Widget Function(BuildContext context, bool isActive, VoidCallback toggle);

typedef SpeedDialItemBuilder<T> = Widget Function(BuildContext context, T item, int index, Animation<double> animation);

/// This widget can be used to create speed dial buttons of all kinds of styles.
///
/// The most Basic example of a typically vertical expanding speed dial button looks like this:
///
/// ```dart
/// SpeedDialBuilder(
///   buttonBuilder: (context, isActive, toggle) => FloatingActionButton(
///     onPressed: toggle,
///     child: Icon( isActive ? Icons.close : Icons.add )
///   ),
///   buttonAnchor: Alignment.topCenter,
///   itemAnchor: Alignment.bottomCenter,
///   itemBuilder: (context, Widget item, i, animation) => FractionalTranslation(
///     translation: Offset(0, -i.toDouble()),
///     child: ScaleTransition(
///       scale: animation,
///       child: item
///     )
///   ),
///   items: [
///     FloatingActionButton.small(
///       onPressed: () {},
///       child: const Icon(Icons.hub),
///     ),
///     ...
///   ]
/// );
/// ```
///
/// Checkout the example or readme of the project for further details and more advanced examples.

class SpeedDialBuilder<T> extends StatefulWidget {
  /// The main button builder. This will typically return a [FloatingActionButton].
  /// However any widget with an intrinsic size might be returned here.
  ///
  /// When implementing this you should pass the [toggle] function to your `onPress` callback.
  ///
  /// The [isActive] parameter indicates whether the button is disclosed/active or collapsed/inactive.
  /// This can be used to change the style of the button for example by using an [AnimatedSwitcher]
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

  /// A list of items used by the [itemBuilder] and [secondaryItemBuilder].
  ///
  /// For speed dials without labels you might directly pass the sub-buttons as widgets here.
  ///
  /// If you want to show labels using the [secondaryItemBuilder] then either pass the necessary data
  /// with a custom class, a list of [Map]s, or a Tuple from the [tuple package](https://pub.dev/packages/tuple).
  final List<T> items;

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
  }) :
    assert(
      animationOverlap >= 0 && animationOverlap <= 1,
      'The value of the `animationOverlap` property should lie between 0 (successive animation) and 1 (simultaneous animation).'
    ),
    super(key: key);


  @override
  State createState() => _SpeedDialBuilderState<T>();
}


class _SpeedDialBuilderState<T> extends State<SpeedDialBuilder<T>> with SingleTickerProviderStateMixin {
  late double _intervalLength, _intervalOffset;

  final _buttonLayerLink = LayerLink();

  late final _controller = AnimationController(vsync: this);

  late final _overlayEntry = OverlayEntry(
    builder: _overlayEntryBuilder
  );

  @override
  void initState() {
    super.initState();

    _calcAnimationValues();

    _controller.addStatusListener((status) {
      // trigger rebuild to reflect updates to the "isActive" state
      setState(() {
        if (status == AnimationStatus.dismissed) {
          // remove overlay / hide speed dial buttons
          _overlayEntry.remove();
        }
      });
    });
  }


  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    _calcAnimationValues();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _overlayEntry.markNeedsBuild()
    );
  }

  // trigger overlay rebuild on hot reload
  @override
  void reassemble() {
    super.reassemble();

    _calcAnimationValues();

    _overlayEntry.markNeedsBuild();
  }


  // pre calculate necessary variables
  void _calcAnimationValues() {
    // calculate animation scale factor based on overlap value and number of entries
    final animationLengthScale = 1 + ((1 - widget.animationOverlap) * (widget.items.length - 1));

    // the length of one sub interval in a total interval from 0 to 1
    _intervalLength = 1 / animationLengthScale;

    // the length of one overlap in a sub interval
    final overlapLength = _intervalLength * widget.animationOverlap;

    // the non-overlapping length of one sub interval
    _intervalOffset = _intervalLength - overlapLength;

    // stretch length by amount of items minus the animation overlap
    _controller.duration = widget.duration * animationLengthScale;
    _controller.reverseDuration = widget.reverseDuration * animationLengthScale;
  }


  Widget _overlayEntryBuilder(BuildContext overlayContext) {
    return Stack(
      children: [
        // align every item to the main button
        ...Iterable.generate(
          widget.items.length,
          (i) => CompositedTransformFollower(
            link: _buttonLayerLink,
            targetAnchor: widget.buttonAnchor,
            followerAnchor: widget.itemAnchor,
            offset: widget.offset,
            child: widget.itemBuilder(
              overlayContext, widget.items[i], i, _getAnimation(i)
            )
          )
        ),
        // add secondary items to stack/overlay if a builder is defined
        // this also aligns every item to the main button for consistency
        if (widget.secondaryItemBuilder != null) ...Iterable.generate(
          widget.items.length,
          (i) => CompositedTransformFollower(
            link: _buttonLayerLink,
            targetAnchor: widget.buttonAnchor,
            followerAnchor: widget.itemAnchor,
            offset: widget.offset,
            child: widget.secondaryItemBuilder!(
              overlayContext, widget.items[i], i, _getAnimation(i)
            )
          )
        )
      ]
    );
  }


  CurvedAnimation _getAnimation(int index) {
    index = widget.reverse ? widget.items.length - index - 1 : index;

    final start = index * _intervalOffset;
    final end = start + _intervalLength;

    return CurvedAnimation(
      parent: _controller,
      curve: Interval(
        start,
        end,
        curve: widget.curve
      ),
      reverseCurve: Interval(
        start,
        end,
        curve: widget.reverseCurve
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _buttonLayerLink,
      child:  widget.buttonBuilder(context, isActive, toggle)
    );
  }

  /// Whether the speed dial is open or closed.

  bool get isActive {
    return _controller.status == AnimationStatus.forward || _controller.status == AnimationStatus.completed;
  }

  /// Open/Close the speed dial.

  void toggle() {
    if (_controller.isDismissed) {
      Overlay.of(context)?.insert(_overlayEntry);
      _controller.forward();
    }
    else {
      _controller.reverse();
    }
  }


  @override
  void dispose() {
    _controller.dispose();

    // this is required since the widget might be unmounted in a later frame
    _overlayEntry.addListener(() {
      if (!_overlayEntry.mounted) {
        _overlayEntry.dispose();
      }
    });

    super.dispose();
  }
}
