/// Currently, just copy pasted from https://pub.dev/packages/diffutil_sliverlist
/// But with some of our needs
///
/// Also, will be modify later

import 'package:diffutil_dart/diffutil.dart' as diffutil;
import 'package:flutter/widgets.dart';

typedef AnimatedDiffUtilWidgetBuilder = Widget Function(
  BuildContext,
  Animation<double>,
  Widget,
);

class DiffUtilSliverList<T> extends StatefulWidget {
  /// the (immutable) list of items
  final List<T> items;

  /// builder that renders a single item (without animation)
  final Widget Function(BuildContext, int i, T) builder;

  /// builder that renders the insertion animation
  final AnimatedDiffUtilWidgetBuilder insertAnimationBuilder;

  /// that renders the removal animation
  final AnimatedDiffUtilWidgetBuilder removeAnimationBuilder;
  final Duration insertAnimationDuration;
  final Duration removeAnimationDuration;

  final bool Function(T, T)? equalityChecker;

  const DiffUtilSliverList({
    required this.items,
    required this.builder,
    required this.insertAnimationBuilder,
    required this.removeAnimationBuilder,
    this.insertAnimationDuration = const Duration(milliseconds: 300),
    this.removeAnimationDuration = const Duration(milliseconds: 300),
    this.equalityChecker,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DiffUtilSliverListState<T> createState() => _DiffUtilSliverListState<T>();
}

class _DiffUtilSliverListState<T> extends State<DiffUtilSliverList<T>> {
  late GlobalKey<SliverAnimatedListState> listKey;

  late List<T?> tempList;

  @override
  void initState() {
    super.initState();
    listKey = GlobalKey<SliverAnimatedListState>();
  }

  @override
  void didUpdateWidget(DiffUtilSliverList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final tempList = oldWidget.items;
    final newList = widget.items;

    final diff = diffutil
        .calculateListDiff<T>(
          tempList,
          newList,
          detectMoves: false,
          equalityChecker: widget.equalityChecker,
        )
        .getUpdates(batch: true);

    this.tempList = List<T?>.of(tempList);
    diff.forEach(_onDiffUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: listKey,
      initialItemCount: widget.items.length,
      itemBuilder: (context, index, animation) => widget.insertAnimationBuilder(
        context,
        animation,
        widget.builder(context, index, widget.items[index]),
      ),
    );
  }

  void _onChanged(int position, Object? payload) {
    listKey.currentState!.removeItem(
        position, (context, animation) => const SizedBox.shrink(),
        duration: const Duration());
    _onInserted(position, 1);
  }

  void _onInserted(final int position, final int count) {
    for (var loopCount = 0; loopCount < count; loopCount++) {
      listKey.currentState!.insertItem(position + loopCount,
          duration: widget.insertAnimationDuration);
    }
    tempList.insertAll(position, List<T?>.filled(count, null));
  }

  void _onRemoved(final int position, final int count) {
    for (int loopCount = 0; loopCount < count; loopCount++) {
      final oldItem = tempList[position + loopCount];

      if (oldItem == null) {
        continue;
      }

      // i purposefully remove the item at the same position on each
      // turn. the internal state is updated, so it removes the right item
      // actually. i only need to calculate the position of oldList
      // which might get ot of sync if count > 1.
      // the tempList is only updated at the end of the method for better performance
      listKey.currentState!.removeItem(
        position,
        (context, animation) => widget.removeAnimationBuilder(
          context,
          animation,
          widget.builder(context, position, oldItem),
        ),
        duration: widget.removeAnimationDuration,
      );
    }
    tempList.removeRange(position, position + count);
  }

  void _onDiffUpdate(diffutil.DiffUpdate update) {
    update.when<void>(
      move: (_, __) =>
          throw UnimplementedError('moves are currently not supported'),
      insert: _onInserted,
      change: _onChanged,
      remove: _onRemoved,
    );
  }
}
