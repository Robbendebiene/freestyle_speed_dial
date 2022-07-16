import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freestyle_speed_dial/freestyle_speed_dial.dart';
import 'package:tuple/tuple.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
        materialTapTargetSize:  MaterialTapTargetSize.padded
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox.expand(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              // Example 1 (Vertical Pop-In):
              // Simple speed dial where every sub-button/item animates starting
              // from its own final position.
              SpeedDialBuilder(
                buttonBuilder: (context, isActive, toggle) => FloatingActionButton(
                  onPressed: toggle,
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubicEmphasized,
                    turns: isActive ? 0.125 : 0,
                    child: const Icon( Icons.add )
                  )
                ),
                buttonAnchor: Alignment.topCenter,
                itemAnchor: Alignment.bottomCenter,
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
                  ),
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.wallet),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.sd_card),
                  )
                ]
              ),


              // Example 2 (Vertical Slide-In-Place):
              // Simple speed dial where every sub-button/item animates starting
              // from the FABs position to its final position.
              SpeedDialBuilder(
                buttonBuilder: (context, isActive, toggle) => FloatingActionButton(
                  onPressed: toggle,
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubicEmphasized,
                    turns: isActive ? 0.125 : 0,
                    child: const Icon( Icons.add )
                  )
                ),
                curve: Curves.easeInOutCubicEmphasized,
                reverse: true,
                itemBuilder: (context, Widget item, i, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: Offset.zero,
                    end: Offset(0, -i - 1),
                  ).animate(animation);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: item,
                    )
                  );
                },
                items: [
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.hub),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.file_download),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.wallet),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.sd_card),
                  )
                ]
              ),


              // Example 3 (Diagonal Slide-In-Place):
              // Simple speed dial where every sub-button/item animates starting
              // from the FABs position to its final position.
              SpeedDialBuilder(
                buttonAnchor: Alignment.center,
                itemAnchor: Alignment.center,
                buttonBuilder: (context, isActive, toggle) => FloatingActionButton(
                  onPressed: toggle,
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubicEmphasized,
                    turns: isActive ? 0.125 : 0,
                    child: const Icon( Icons.add )
                  )
                ),
                curve: Curves.easeInOutCubicEmphasized,
                reverse: true,
                itemBuilder: (context, Widget item, i, animation) {
                  // radius in relative units to each item
                  const radius = 1.3;
                  // angle in radians
                  const angle = -3/4 * pi;

                  final targetOffset = Offset(
                    (i + radius) * cos(angle),
                    (i + radius) * sin(angle)
                  );

                  final offsetAnimation = Tween<Offset>(
                    begin: Offset.zero,
                    end: targetOffset
                  ).animate(animation);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: item,
                    )
                  );
                },
                items: [
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.hub),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.file_download),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.wallet),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.sd_card),
                  )
                ]
              ),


              // Example 4 (Radial Slide-In-Place):
              // Simple speed dial where every sub-button/item animates starting
              // from the FABs position to its final position.
              SpeedDialBuilder(
                buttonAnchor: Alignment.center,
                itemAnchor: Alignment.center,
                buttonBuilder: (context, isActive, toggle) => FloatingActionButton(
                  onPressed: toggle,
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubicEmphasized,
                    turns: isActive ? 0.125 : 0,
                    child: const Icon( Icons.add )
                  )
                ),
                itemBuilder: (context, Widget item, i, animation) {
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
                      child: item,
                    )
                  );
                },
                items: [
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.hub),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.file_download),
                  ),
                  FloatingActionButton.small(
                    onPressed: () {},
                    child: const Icon(Icons.wallet),
                  ),
                ]
              ),


              // Example 5 (Vertical Pop-In With Labels):
              // Advanced speed dial where every sub-button/item has an additional label.
              // Both the item and the label start animating from their target position.
              SpeedDialBuilder(
                buttonAnchor: Alignment.topCenter,
                itemAnchor: Alignment.bottomCenter,
                buttonBuilder: (context, isActive, toggle) => FloatingActionButton(
                  onPressed: toggle,
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubicEmphasized,
                    turns: isActive ? 0.125 : 0,
                    child: const Icon( Icons.add )
                  )
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
                  ),
                  Tuple3<IconData, String, LayerLink>(
                    Icons.ice_skating_outlined, 'Ice', LayerLink()
                  )
                ]
              ),


              // Example 6 (Vertical Slide-In-Place With Labels):
              // Advanced speed dial where every sub-button/item has an additional label.
              // Both the item and the label start animating from their target position.
              SpeedDialBuilder(
                buttonBuilder: (context, isActive, toggle) => FloatingActionButton(
                  onPressed: toggle,
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubicEmphasized,
                    turns: isActive ? 0.125 : 0,
                    child: const Icon( Icons.add )
                  )
                ),
                reverse: true,
                itemBuilder: (context, Tuple3<IconData, String, LayerLink> item, i, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: Offset.zero,
                    end: Offset(0, -i - 1),
                  ).animate(animation);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: animation,
                      child: CompositedTransformTarget(
                        link: item.item3,
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
                  ),
                  Tuple3<IconData, String, LayerLink>(
                    Icons.ice_skating_outlined, 'Ice', LayerLink()
                  )
                ]
              ),
            ]
          )
        )
      )
    );
  }
}
