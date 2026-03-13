import 'package:e_comm/models/product-model.dart';
import 'package:e_comm/utils/app-constant.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel productModel;

  const ProductDetailsScreen({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    final String productName = productModel.productName.trim().isEmpty
        ? 'Product'
        : productModel.productName;
    final String price = productModel.fullPrice.trim().isEmpty
        ? productModel.salePrice
        : productModel.fullPrice;
    final String category = productModel.categoryName.trim().isEmpty
        ? 'Uncategorized'
        : productModel.categoryName;
    final String description = productModel.productDescription.trim().isEmpty
        ? 'No description available'
        : productModel.productDescription;
    final String imageUrl = productModel.productImages.isNotEmpty
        ? productModel.productImages.first
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 280,
                      color: Colors.grey.shade100,
                      child: imageUrl.isEmpty
                          ? Icon(
                              Icons.image_not_supported_outlined,
                              size: 72,
                              color: Colors.grey.shade500,
                            )
                          : Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.broken_image_outlined,
                                size: 72,
                                color: Colors.grey.shade500,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'PKR $price',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppConstant.appMainColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cart feature coming next'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.appMainColor,
                    foregroundColor: AppConstant.appTextColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Add to Cart'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
