// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  final String headingTitle;
  final String headingSubTitle;
  final VoidCallback onTap;
  final String buttonText;

  const HeadingWidget({
    super.key,
    required this.headingTitle,
    required this.headingSubTitle,
    required this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(headingTitle),
      subtitle: Text(headingSubTitle),
      trailing: TextButton(
        onPressed: onTap,
        child: Text(buttonText),
      ),
    );
  }
}
