This package provides a single lightweight widget called `SpeedDialBuilder` which allows you to build custom speed dial buttons of all kinds of styles.

It offers full control over the appearance, layout and animations of the sub-buttons and secondary widgets like button labels.

## Examples

Run the example project to see some example layouts and animations or watch the [demo video](https://raw.githubusercontent.com/Robbendebiene/freestyle_speed_dial/master/resources/examples.mp4).

[<img src="https://raw.githubusercontent.com/Robbendebiene/freestyle_speed_dial/master/resources/examples.png" />](https://raw.githubusercontent.com/Robbendebiene/freestyle_speed_dial/master/resources/examples.mp4)


## Usage

### Building the main button

The starting point of ever speed dial button is a main toggle button. Use the `buttonBuilder` to create your own custom toggle button. You can use any combination of widgets there. The only important thing is, that one of the widgets must call the `toggle` function provided by the builder on your desired user interaction.
To reflect the state of the speed dial you can alter your widget based on the `isActive` parameter. To transition between both states consider using an `AnimatedSwitcher` or any other [flutter implicitly animated widget](https://api.flutter.dev/flutter/widgets/ImplicitlyAnimatedWidget-class.html).

Basic example code:


```dart
SpeedDialBuilder(
  ...
  buttonBuilder: (context, isActive, toggle) => FloatingActionButton(
    onPressed: toggle,
    child: Icon( isActive ? Icons.close : Icons.add )
  )
)
```

### Adding items and creating sub-buttons

The items of the speed dial must be passed to the `items` property. There you have the option to either directly pass your widgets or any other data type like a custom container class. The passed items will be available in the `itemBuilder` where you can further specify their appearance, layout and animation.

For now lets focus on a simple example where we directly pass two items as small `FloatingActionButton` widgets.

```dart
SpeedDialBuilder(
  ...
  items: [
    FloatingActionButton.small(
      onPressed: () {},
      child: const Icon(Icons.hub),
    ),
    FloatingActionButton.small(
      onPressed: () {},
      child: const Icon(Icons.file_download),
    )
  ]
)
```

In the `itemBuilder` we position our items vertically using the supplied item index and the `FractionalTranslation` widget.

Additionally we wrap every item in a `ScaleTransition` and pass it the provided `animation` object in order to get a nice in and out transition for every item. You can further control the animation with the `animationOverlap`, `reverse`, `duration`, `reverseDuration`, `curve` and `reverseCurve` properties of the `SpeedDialBuilder`.


```dart
SpeedDialBuilder(
  ...
  buttonAnchor: Alignment.topCenter,
  itemAnchor: Alignment.bottomCenter,
  itemBuilder: (context, Widget item, i, animation) => FractionalTranslation(
    translation: Offset(0, -i.toDouble()),
    child: ScaleTransition(
      scale: animation,
      child: item
    )
  )
)
```

You may have noticed that two additional properties `buttonAnchor` and `itemAnchor` slipped in. These only control the initial item position before they get translated in the `itemBuilder`. In this case they are placed right above the main button.
Think of it as defining two points, one on the main button that is fixed and one for every item. Both points are then brought together by repositioning the item.

### Complete example code

```dart
SpeedDialBuilder(
  buttonAnchor: Alignment.topCenter,
  itemAnchor: Alignment.bottomCenter,
  buttonBuilder: (context, isActive, toggle) => FloatingActionButton(
    onPressed: toggle,
    child: Icon( isActive ? Icons.close : Icons.add )
  ),
  itemBuilder: (context, Widget item, i, animation) => FractionalTranslation(
    translation: Offset(0, -i.toDouble()),
    child: ScaleTransition(
      scale: animation,
      child: item
    )
  ),
  items: [
    FloatingActionButton.small(
      onPressed: () {},
      child: const Icon(Icons.hub),
    ),
    FloatingActionButton.small(
      onPressed: () {},
      child: const Icon(Icons.file_download),
    )
  ]
)
```

### Display labels beneath the items

To freely display labels beneath every item you can use the `secondaryItemBuilder`. In this case you need to pass data objects describing your buttons and labels instead of a single widget to the `items` property. The construction of your widgets (buttons and labels) should then be performed inside the builder methods.
Alternatively you can also directly include the label in the `itemBuilder` for example using a row. However this approach might make aligning the items a bit harder.

The below example uses the `secondaryItemBuilder` in combination with Flutters [CompositedTransformTarget](https://api.flutter.dev/flutter/widgets/CompositedTransformTarget-class.html) and [CompositedTransformFollower](https://api.flutter.dev/flutter/widgets/CompositedTransformFollower-class.html) widgets to show a label beneath every item.

```dart
SpeedDialBuilder(
  buttonAnchor: Alignment.topCenter,
  itemAnchor: Alignment.bottomCenter,
  buttonBuilder: (context, isActive, toggle) => FloatingActionButton(
    onPressed: toggle,
    child: Icon( isActive ? Icons.close : Icons.add )
  ),
  itemBuilder: (context, Tuple3<IconData, String, LayerLink> item, i, animation) {
    return FractionalTranslation(
      translation: Offset(0, -i.toDouble()),
      child: CompositedTransformTarget(
        link: item.item3,
        child: ScaleTransition(
          scale: animation,
          child: FloatingActionButton.small(
            onPressed: () {},
            child: Icon(item.item1),
          ),
        )
      )
    );
  },
  secondaryItemBuilder: (context, Tuple3<IconData, String, LayerLink> item, i, animation) {
    return CompositedTransformFollower(
      link: item.item3,
      targetAnchor: Alignment.centerRight,
      followerAnchor: Alignment.centerLeft,
      child: FadeTransition(
        opacity: animation,
        child: Card(
          margin: const EdgeInsets.only( left: 10 ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(item.item2),
          )
        )
      )
    );
  },
  items: [
    // You can also define and use your own container class
    // if you don't want to use the tuple package.
    Tuple3<IconData, String, LayerLink>(
      Icons.hub, 'Hub', LayerLink()
    ),
    Tuple3<IconData, String, LayerLink>(
      Icons.track_changes, 'Track', LayerLink()
    )
  ]
)
```