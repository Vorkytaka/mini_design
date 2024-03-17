import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mini_design/mini_design.dart';

class ComponentsPage extends StatelessWidget {
  static const path = '/components';

  const ComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.maybePaddingOf(context);
    const divider = SizedBox(height: 24);

    return RevertBackgroundTheme(
      child: Scaffold(
        appBar: AppBar(title: const Text('Components')),
        body: ListView(
          padding: EdgeInsets.only(
            left: 12,
            top: padding?.top ?? 0,
            right: 12,
            bottom: padding?.bottom ?? 0,
          ),
          children: [
            const MiniGroupHeader(header: Text('SEARCH BAR')),
            const MiniSearchBar(
              hint: 'Поиск',
            ),
            divider,
            MiniGroup(
              header: const Text('MINI LIST TILE'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MiniListTile(
                    title: const Text('Title'),
                    onTap: () {},
                  ),
                  MiniListTile(
                    title: const Text('Title'),
                    subtitle: const Text('Subtitle'),
                    onTap: () {},
                  ),
                  MiniListTile(
                    title: const Text('Title'),
                    leading: const MiniSettingIcon(
                      color: Colors.red,
                      icon: Icon(Icons.folder),
                    ),
                    onTap: () {},
                  ),
                  MiniListTile(
                    title: const Text('Title'),
                    subtitle: const Text('Subtitle'),
                    leading: const MiniSettingIcon(
                      color: Colors.blue,
                      icon: Icon(Icons.folder),
                    ),
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('33'),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                  MiniListTile(
                    leading: const MiniSettingIcon(
                      color: Colors.green,
                      icon: Icon(Icons.folder),
                    ),
                    title: const Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et'),
                    onTap: () {},
                  ),
                ].interpose(const MiniGroupDivider()),
              ),
            ),
            divider,
            MiniGroup(
              header: const Text('MINI TEXT FIELD'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MiniTextField(
                    hint: 'Hint',
                  ),
                  MiniTextFormField(
                    hint: 'Form field hint',
                    validator: (str) =>
                        str != null && str.isNotEmpty ? 'Error' : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const MiniTextField(
                    hint: 'Multiline hint',
                    minLines: 5,
                    maxLines: 5,
                  ),
                ].interpose(const MiniGroupDivider(indent: 0)),
              ),
            ),
            divider,
            const MiniGroup(
              header: Text('MINI CHECKBOX'),
              child: _CheckboxExample(),
            ),
            divider,
            MiniGroup(
              header: const Text('MINI COLOR PICKER'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const _ColorPickerExample(),
                  const _ColorPickerExample(
                    colors: [
                      Colors.red,
                      Colors.green,
                      Colors.blue,
                    ],
                  ),
                  const _ColorPickerExample(
                    selectedColor: Colors.green,
                  ),
                  _ColorPickerExample(
                    mode: defaultTargetPlatform.isDesktop
                        ? MiniColorPickerMode.scroll
                        : MiniColorPickerMode.wrap,
                  ),
                ].interpose(const MiniGroupDivider(indent: 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckboxExample extends StatefulWidget {
  const _CheckboxExample();

  @override
  State<_CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<_CheckboxExample> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MiniCheckbox(
          value: _isChecked,
          onChanged: _onTap,
        ),
        MiniCheckbox(
          value: _isChecked,
          onChanged: _onTap,
          size: 40,
          side: const BorderSide(width: 3),
          bubbleCount: 10,
        ),
        MiniCheckbox(
          value: _isChecked,
          onChanged: _onTap,
          checkColor: Colors.orange,
          fillColor: Colors.blue,
        ),
        MiniCheckbox(
          value: _isChecked,
          onChanged: _onTap,
          bubbleCount: 0,
        ),
        MiniCheckbox(
          value: _isChecked,
          onChanged: _onTap,
          bubbleColors: const [Colors.red],
          fillColor: Colors.red,
        ),
      ],
    );
  }

  void _onTap(bool isChecked) => setState(() {
        _isChecked = isChecked;
      });
}

class _ColorPickerExample extends StatefulWidget {
  final List<Color> colors;
  final Color? selectedColor;
  final MiniColorPickerMode mode;

  const _ColorPickerExample({
    this.colors = MiniColorPicker.primaryColors,
    this.selectedColor,
    this.mode = MiniColorPickerMode.auto,
  });

  @override
  State<_ColorPickerExample> createState() => _ColorPickerExampleState();
}

class _ColorPickerExampleState extends State<_ColorPickerExample> {
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return MiniColorPicker(
      mode: widget.mode,
      colors: widget.colors,
      selectedColor: _selectedColor,
      onChanged: (color) => setState(() {
        _selectedColor = color;
      }),
    );
  }
}
