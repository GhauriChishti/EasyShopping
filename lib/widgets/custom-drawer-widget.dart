// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: SafeArea(
        child: ListTile(
          title: Text('Menu'),
        ),
      ),
    );
  }
}
