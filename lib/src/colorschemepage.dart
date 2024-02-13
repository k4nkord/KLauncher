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
        body: ListView(children: [
      const SizedBox(height: 50),
      Container(
        margin: const EdgeInsets.all(5),
        child: TextButton(
            onPressed: () {
              data.darkTheme = !data.darkTheme;
            },
            child: const Text('dark/light theme switcher')),
      ),
      const SizedBox(height: 10),
      Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffc9c9c9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: ColorPicker(
          pickerColor: data.seedColor,
          onColorChanged: (color) {
            data.seedColor = color;
          },
          colorPickerWidth: 200,
        ),
      ),
      Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xffc9c9c9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ColorPicker(
            pickerColor: data.secondaryColor,
            onColorChanged: (color) {
              data.secondaryColor = color;
            },
            colorPickerWidth: 200,
          )),
    ]));
  }
}
