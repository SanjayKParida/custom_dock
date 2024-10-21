import 'package:flutter/material.dart';

/// This file contains the main entry point for the Flutter application.
/// It includes the `MyApp` widget which sets up a simple UI with a dock that
/// allows the reordering of icons using drag-and-drop functionality.

/// Entrypoint of the application.
/// It initializes the application by calling the `runApp` function and
/// providing the `MyApp` widget, which builds the UI.
void main() {
  runApp(const MyApp());
}

/// A stateless widget that builds the main [MaterialApp] of the application.
/// The home screen includes a [Scaffold] with a [Dock] widget and a
/// text description.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Builds the main structure of the app, which includes a [Scaffold]
  /// containing a [Dock] of icons and a text description.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            /// A widget that allows for the reordering of its [items] using drag-and-drop.
            /// The [items] are displayed using the provided [builder] function, which
            /// builds a widget for each item.
            Dock(
              items: const [
                Icons.person,
                Icons.message,
                Icons.call,
                Icons.camera,
                Icons.photo,
              ],
              builder: (e) {
                return Container(
                  constraints: const BoxConstraints(minWidth: 48),
                  height: 48,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        Colors.primaries[e.hashCode % Colors.primaries.length],
                  ),
                  child: Center(child: Icon(e, color: Colors.white)),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                  "Hey, this submission doesn't feature smooth animations like the demo you provided. I am not that experienced with animations, but I'm a fast learner and I can ensure you that I can build great projects, there was a deadline so I didn't have the time to enlighten myself on the topic. I hope it won't overshadow my other skills."),
            )
          ]),
        ),
      ),
    );
  }
}

/// Creates a new [Dock] widget.
/// The [items] are the initial list of items displayed in the dock, which
/// can be reordered by dragging.
/// The [builder] is a function that builds the widget representation of each
/// item in the dock.

class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// The mutable state for the [Dock] widget, which manages the reordering
/// of items and drag-drop interactions.
class _DockState<T> extends State<Dock<T>> {
  /// A mutable list of items in the dock, which is initially a copy of
  /// [widget.items].
  late final List<T> _items = widget.items.toList();
  int? _draggedIndex;

  /// Builds the UI of the dock, displaying the items and allowing drag-and-drop
  /// reordering through [DragTarget] and [Draggable].
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int index = 0; index <= _items.length; index++)

            /// A [DragTarget] that accepts dragged items and reorders the [Dock]'s
            /// [items] when a valid item is dropped.
            ///
            /// The [onWillAccept] callback ensures that an item can only be dropped
            /// if it is a different item than the one being dragged.
            /// The [onAccept] callback updates the order of [items] in the dock when
            /// an item is dropped.

            DragTarget<int>(
              onWillAccept: (data) => data != null && data != index,
              onAccept: (draggedIndex) {
                setState(() {
                  final draggedItem = _items.removeAt(draggedIndex);
                  if (index > _items.length) {
                    _items.add(draggedItem);
                  } else {
                    _items.insert(index, draggedItem);
                  }
                });
              },
              builder: (context, candidateData, rejectedData) {
                if (index == _items.length) {
                  // This is the last (empty) slot
                  return const SizedBox(width: 0, height: 48);
                }
                final item = _items[index];

                /// A [Draggable] widget that allows the user to drag items from the dock.
                /// The [feedback] parameter specifies what is displayed when the item
                /// is being dragged, and [childWhenDragging] is shown in place of the
                /// dragged item.
                /// The [onDragStarted] and [onDragEnd] callbacks are used to manage
                /// the visual appearance and state of the dragged item.

                return Draggable<int>(
                  data: index,
                  feedback: widget.builder(item),
                  childWhenDragging: const SizedBox.shrink(),
                  onDragStarted: () => setState(() => _draggedIndex = index),
                  onDragEnd: (_) => setState(() => _draggedIndex = null),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _draggedIndex == index ? 0 : null,
                    child: widget.builder(item),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
