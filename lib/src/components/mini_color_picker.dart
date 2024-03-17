import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const _kItemDimension = 56.0;

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

  const MiniColorPicker({
    Key? key,
    this.colors = primaryColors,
    this.selectedColor,
    this.onChanged,
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
    // TODO(Vorkytaka): Draw colors as a grid for desktops, because we cannot scroll horizontally with mouse
    return SizedBox(
      height: _kItemDimension,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(
          // Hack for desktop
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        child: ListView.builder(
          controller: _controller,
          itemExtent: _kItemDimension,
          itemCount: widget.colors.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, i) {
            final color = widget.colors[i];
            final isSelected = widget.selectedColor?.value == color.value;
            return _Item(
              color: color,
              isSelected: isSelected,
              onChanged: widget.onChanged,
            );
          },
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
