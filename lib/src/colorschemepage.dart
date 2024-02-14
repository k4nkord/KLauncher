import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'data.dart';

class ColorSchemePage extends StatelessWidget {
  Color? pickerColor1;
  Color? pickerColor2;

  ColorSchemePage({super.key});

  @override
  Widget build(BuildContext context) {
    var data = context.watch<Data>();
    pickerColor1 ??= data.seedColor;
    pickerColor2 ??= data.secondaryColor;
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
      Container(
        margin: const EdgeInsets.all(5),
        child: TextButton(
            onPressed: () {
              data.seedColor = pickerColor1!;
              data.secondaryColor = pickerColor2!;
            },
            child: const Text('apply colorscheme')),
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
          pickerColor: pickerColor1!,
          onColorChanged: (color) {
            pickerColor1 = color;
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
            pickerColor: pickerColor2!,
            onColorChanged: (color) {
              pickerColor2 = color;
            },
            colorPickerWidth: 200,
          )),
    ]));
  }
}
