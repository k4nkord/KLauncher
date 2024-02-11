import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
            color: Theme.of(context).textTheme.bodyMedium!.color));
  }
}
