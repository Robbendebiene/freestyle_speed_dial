import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freestyle_speed_dial/freestyle_speed_dial.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
        materialTapTargetSize:  MaterialTapTargetSize.padded
      ),
      home: const ExamplePage()
    );
  }
}


class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: min(200, MediaQuery.of(context).size.width/3),
            vertical: 200
          ),
          child: Wrap(
            spacing: 200,
            runSpacing: 200,
            children: [


              // Example 1 (Vertical Pop-In):
              // Simple speed dial where every sub-button/item animates starting
              // from its own final position.
              SpeedDialBuilder(
                buttonBuilder: spinButtonBuilder,
                buttonAnchor: Alignment.topCenter,
                itemAnchor: Alignment.bottomCenter,
                itemBuilder: (context, Widget item, i, animation, controller) => FractionalTranslation(
                  translation: Offset(0, -i.toDouble()),
                  child: ScaleTransition(
                    scale: animation,
                    child: FloatingActionButton.small(
                      onPressed: controller.close,
                      child: item,
                    ),
                  )
                ),
                items: const [
                  Icon(Icons.hub),
                  Icon(Icons.file_download),
                  Icon(Icons.wallet),
                  Icon(Icons.sd_card),
                ]
              ),


              // Example 2 (Vertical Slide-In-Place):
              // Simple speed dial where every sub-button/item animates starting
              // from the FABs position to its final position.
              SpeedDialBuilder(
                buttonBuilder: spinButtonBuilder,
                curve: Curves.easeInOutCubicEmphasized,
                reverse: true,
                itemBuilder: (context, Widget item, i, animation, controller) {
                  final offsetAnimation = Tween<Offset>(
                    begin: Offset.zero,
                    end: Offset(0, -i - 1),
                  ).animate(animation);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: FloatingActionButton.small(
                        onPressed: controller.close,
                        child: item,
                      ),
                    )
                  );
                },
                items: const [
                  Icon(Icons.hub),
                  Icon(Icons.file_download),
                  Icon(Icons.wallet),
                  Icon(Icons.sd_card),
                ]
              ),


              // Example 3 (Diagonal Slide-In-Place):
              // Simple speed dial where every sub-button/item animates starting
              // from the FABs position to its final position.
              SpeedDialBuilder(
                buttonAnchor: Alignment.center,
                itemAnchor: Alignment.center,
                buttonBuilder: spinButtonBuilder,
                curve: Curves.easeInOutCubicEmphasized,
                reverse: true,
                itemBuilder: (context, Widget item, i, animation, controller) {
                  // radius in relative units to each item
                  const radius = 1.3;
                  // item spacing
                  const spacing = 0.1;
                  // angle in radians
                  const angle = -3/4 * pi;

                  final targetOffset = Offset(
                    (i + radius) * cos(angle) - i * spacing,
                    (i + radius) * sin(angle) - i * spacing
                  );

                  final offsetAnimation = Tween<Offset>(
                    begin: Offset.zero,
                    end: targetOffset
                  ).animate(animation);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: FloatingActionButton.small(
                        onPressed: controller.close,
                        child: item,
                      ),
                    )
                  );
                },
                items: const [
                  Icon(Icons.hub),
                  Icon(Icons.file_download),
                  Icon(Icons.wallet),
                  Icon(Icons.sd_card),
                ]
              ),


              // Example 4 (Radial Slide-In-Place):
              // Simple speed dial where every sub-button/item animates starting
              // from the FABs position to its final position.
              SpeedDialBuilder(
                buttonAnchor: Alignment.center,
                itemAnchor: Alignment.center,
                buttonBuilder: spinButtonBuilder,
                itemBuilder: (context, Widget item, i, animation, controller) {
                  // radius in relative units to each item
                  const radius = 1.3;
                  // angle in radians
                  final angle = i * (pi/4) + pi;

                  final targetOffset = Offset(
                    radius * cos(angle),
                    radius * sin(angle)
                  );

                  final offsetAnimation = Tween<Offset>(
                    begin: Offset.zero,
                    end: targetOffset,
                  ).animate(animation);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: FloatingActionButton.small(
                        onPressed: controller.close,
                        child: item,
                      ),
                    )
                  );
                },
                items: const [
                  Icon(Icons.hub),
                  Icon(Icons.file_download),
                  Icon(Icons.wallet),
                ]
              ),


              // Example 5 (Vertical Pop-In With Labels):
              // Advanced speed dial where every sub-button/item has an additional label.
              // Both the item and the label start animating from their target position.
              SpeedDialBuilder(
                buttonAnchor: Alignment.topCenter,
                itemAnchor: Alignment.bottomCenter,
                buttonBuilder: spinButtonBuilder,
                itemBuilder: (context, (IconData, String, LayerLink) item, i, animation, controller) {
                  return FractionalTranslation(
                    translation: Offset(0, -i.toDouble()),
                    child: CompositedTransformTarget(
                      link: item.$3,
                      child: ScaleTransition(
                        scale: animation,
                        child: FloatingActionButton.small(
                          onPressed: controller.close,
                          child: Icon(item.$1),
                        ),
                      )
                    )
                  );
                },
                secondaryItemBuilder: (context, (IconData, String, LayerLink) item, i, animation, controller) {
                  return CompositedTransformFollower(
                    link: item.$3,
                    targetAnchor: Alignment.centerRight,
                    followerAnchor: Alignment.centerLeft,
                    child: FadeTransition(
                      opacity: animation,
                      child: Card(
                        margin: const EdgeInsets.only( left: 10 ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(item.$2),
                        )
                      )
                    )
                  );
                },
                items: [
                  // You can also define and use your own container class
                  // if you don't want to use records.
                  (Icons.hub, 'Hub', LayerLink()),
                  (Icons.track_changes, 'Track', LayerLink()),
                  (Icons.ice_skating_outlined, 'Ice', LayerLink()),
                ]
              ),


              // Example 6 (Vertical Slide-In-Place With Labels):
              // Advanced speed dial where every sub-button/item has an additional label.
              // Both the item and the label start animating from their target position.
              SpeedDialBuilder(
                buttonBuilder: spinButtonBuilder,
                reverse: true,
                itemBuilder: (context, (IconData, String, LayerLink) item, i, animation, controller) {
                  final offsetAnimation = Tween<Offset>(
                    begin: Offset.zero,
                    end: Offset(0, -i - 1),
                  ).animate(animation);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: CompositedTransformTarget(
                        link: item.$3,
                        child: FloatingActionButton.small(
                          onPressed: controller.close,
                          child: Icon(item.$1),
                        ),
                      )
                    )
                  );
                },
                secondaryItemBuilder: (context, (IconData, String, LayerLink) item, i, animation, controller) {
                  return CompositedTransformFollower(
                    link: item.$3,
                    targetAnchor: Alignment.centerRight,
                    followerAnchor: Alignment.centerLeft,
                    child: FadeTransition(
                      opacity: animation,
                      child: Card(
                        margin: const EdgeInsets.only( left: 10 ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(item.$2),
                        )
                      )
                    )
                  );
                },
                items: [
                  // You can also define and use your own container class
                  // if you don't want to use records.
                  (Icons.hub, 'Hub', LayerLink()),
                  (Icons.track_changes, 'Track', LayerLink()),
                  (Icons.ice_skating_outlined, 'Ice', LayerLink()),
                ]
              ),
            ]
          )
        )
      )
    );
  }
}


Widget spinButtonBuilder(context, controller) => FloatingActionButton(
  onPressed: controller.toggle,
  child: RotationTransition(
    turns: Tween(begin: 0.0, end: 0.125).animate(CurvedAnimation(
      parent: controller.animation,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    )),
    child: const Icon( Icons.add )
  ),
);
