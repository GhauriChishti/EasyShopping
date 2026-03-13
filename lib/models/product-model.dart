// ignore_for_file: file_names

class ProductModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String salePrice;
  final String fullPrice;
  final List<String> productImages;
  final String deliveryTime;
  final bool isSale;
  final String productDescription;
  final dynamic createdAt;
  final dynamic updatedAt;

  ProductModel({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.salePrice,
    required this.fullPrice,
    required this.productImages,
    required this.deliveryTime,
    required this.isSale,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'deliveryTime': deliveryTime,
      'isSale': isSale,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    final dynamic imageField = json['productImages'] ?? json['imageUrl'];

    List<String> parsedImages = [];
    if (imageField is List) {
      parsedImages = imageField.map((e) => e.toString()).toList();
    } else if (imageField is String && imageField.isNotEmpty) {
      parsedImages = [imageField];
    }

    final String fullPriceValue =
        (json['fullPrice'] ?? json['price'] ?? '').toString();

    return ProductModel(
      productId: (json['productId'] ?? '').toString(),
      categoryId: (json['categoryId'] ?? '').toString(),
      productName: (json['productName'] ?? json['name'] ?? '').toString(),
      categoryName:
          (json['categoryName'] ?? json['category'] ?? 'Uncategorized')
              .toString(),
      salePrice: (json['salePrice'] ?? fullPriceValue).toString(),
      fullPrice: fullPriceValue,
      productImages: parsedImages,
      deliveryTime: (json['deliveryTime'] ?? '').toString(),
      isSale: json['isSale'] == true,
      productDescription:
          (json['productDescription'] ?? json['description'] ?? '').toString(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
