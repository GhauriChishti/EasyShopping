// ignore_for_file: file_names

import 'package:e_comm/models/product-model.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel productModel;

  const ProductDetailsScreen({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.productName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(productModel.productDescription),
      ),
    );
  }
}
