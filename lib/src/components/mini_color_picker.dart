import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../base/platform.dart';

const _kItemDimension = 56.0;

enum MiniColorPickerMode {
  auto,
  scroll,
  wrap,
}

class MiniColorPicker extends StatefulWidget {
  static const List<MaterialColor> primaryColors = <MaterialColor>[
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
  ];

  final List<Color> colors;
  final Color? selectedColor;
  final ValueChanged<Color>? onChanged;
  final MiniColorPickerMode mode;

  const MiniColorPicker({
    Key? key,
    this.colors = primaryColors,
    this.selectedColor,
    this.onChanged,
    this.mode = MiniColorPickerMode.auto,
  }) : super(key: key);

  @override
  State<MiniColorPicker> createState() => _MiniColorPickerState();
}

class _MiniColorPickerState extends State<MiniColorPicker> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final selectedColor = widget.selectedColor;
    if (selectedColor != null) {
      final i = widget.colors
          .indexWhere((color) => color.value == selectedColor.value);
      if (i >= 0) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _controller.jumpTo(i * _kItemDimension);
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWrap;
    if (widget.mode == MiniColorPickerMode.wrap) {
      isWrap = true;
    } else if (widget.mode == MiniColorPickerMode.scroll) {
      isWrap = false;
    } else {
      // We use wrap for desktop platform
      // because of problems with horizontal scroll with mouse
      isWrap = defaultTargetPlatform.isDesktop;
    }

    Widget buildItem(int i) {
      final color = widget.colors[i];
      final isSelected = widget.selectedColor?.value == color.value;

      return _Item(
        color: color,
        isSelected: isSelected,
        onChanged: widget.onChanged,
      );
    }

    if (isWrap) {
      return SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          children: [
            for (int i = 0; i < widget.colors.length; i++) buildItem(i),
          ],
        ),
      );
    }

    return SizedBox(
      height: _kItemDimension,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          // Hack for desktop
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.trackpad,
          },
        ),
        child: ListView.builder(
          controller: _controller,
          itemExtent: _kItemDimension,
          itemCount: widget.colors.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, i) => buildItem(i),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final ValueChanged<Color>? onChanged;

  const _Item({
    required this.color,
    required this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => onChanged?.call(color),
      child: SizedBox.square(
        dimension: _kItemDimension,
        child: Center(
          child: SizedBox.square(
            dimension: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: kThemeChangeDuration,
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(
                      isSelected
                          ? BorderSide(
                              color: theme.colorScheme.surface,
                              width: 2.5,
                            )
                          : BorderSide.none,
                    ),
                    shape: BoxShape.circle,
                  ),
                  width: isSelected ? 42 : 48,
                  height: isSelected ? 42 : 48,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
