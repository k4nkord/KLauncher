import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'data.dart';

class ColorSchemePage extends StatelessWidget {
  const ColorSchemePage({super.key});

  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();
    return Scaffold(
      body:
        ListView(children: [
          const SizedBox(height: 50),
          TextButton(
            onPressed: () {
              data.darkTheme = !data.darkTheme;
            },
            child: const Text('dark/light theme switcher')
          ),
          const SizedBox(height: 10),
          ColorPicker(
            pickerColor: data.seedColor,
            onColorChanged: (color) {
              data.seedColor = color;
            },
            colorPickerWidth: 200,
          ),
          ColorPicker(
            pickerColor: data.secondaryColor,
            onColorChanged: (color) {
              data.secondaryColor = color;
            },
            colorPickerWidth: 200,
          )
        ])
    );
  }
}
