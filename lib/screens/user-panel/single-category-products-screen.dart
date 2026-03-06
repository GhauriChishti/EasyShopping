// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AllSingleCategoryProductsScreen extends StatelessWidget {
  final String categoryId;

  const AllSingleCategoryProductsScreen({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Products'),
      ),
      body: Center(
        child: Text('Category: $categoryId'),
      ),
    );
  }
}
