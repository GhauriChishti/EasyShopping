// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/utils/app-constant.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final String fallbackOrderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderData,
    required this.fallbackOrderId,
  });

  String _formatDate(dynamic value) {
    if (value is Timestamp) {
      final DateTime date = value.toDate();
      final String day = date.day.toString().padLeft(2, '0');
      final String month = date.month.toString().padLeft(2, '0');
      final String year = date.year.toString();
      final String hour = date.hour.toString().padLeft(2, '0');
      final String minute = date.minute.toString().padLeft(2, '0');
      return '$day/$month/$year  $hour:$minute';
    }

    return 'Date not available';
  }

  String _statusLabel(dynamic statusValue) {
    final String status = (statusValue ?? '').toString().toLowerCase().trim();

    switch (status) {
      case 'confirmed':
      case 'shipped':
      case 'delivered':
      case 'cancelled':
      case 'pending':
        return status;
      default:
        return status.isEmpty ? 'pending' : status;
    }
  }

  double _parsePrice(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  int _parseQuantity(dynamic value) {
    if (value == null) return 1;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 1;
  }

  String? _extractItemImage(dynamic item) {
    if (item is! Map<String, dynamic>) return null;

    final dynamic directImage = item['image'] ?? item['imageUrl'];
    if (directImage is String && directImage.isNotEmpty) {
      return directImage;
    }

    final dynamic productImages = item['productImages'];
    if (productImages is List && productImages.isNotEmpty) {
      final dynamic firstImage = productImages.first;
      if (firstImage is String && firstImage.isNotEmpty) {
        return firstImage;
      }
    }

    return null;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String orderId =
        (orderData['orderId'] ?? fallbackOrderId).toString();
    final String status = _statusLabel(orderData['status']);
    final double totalPrice = _parsePrice(orderData['totalPrice']);
    final String paymentMethod =
        (orderData['paymentMethod'] ?? 'N/A').toString();
    final String placedAt = _formatDate(orderData['createdAt']);
    final List<dynamic> items = orderData['items'] is List
        ? List<dynamic>.from(orderData['items'])
        : <dynamic>[];

    final Color statusColor = _statusColor(status);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID: $orderId',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        'Status: ${status.toUpperCase()}',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Total: PKR ${totalPrice.toStringAsFixed(0)}'),
                    Text('Payment: $paymentMethod'),
                    Text('Placed: $placedAt'),
                    Text('Items: ${items.length}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Ordered Items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('No item details available for this order.'),
                ),
              ),
            ...items.map((item) {
              final Map<String, dynamic> itemMap =
                  item is Map<String, dynamic> ? item : <String, dynamic>{};
              final String name = (itemMap['name'] ??
                      itemMap['productName'] ??
                      'Unnamed item')
                  .toString();
              final double itemPrice = _parsePrice(
                itemMap['price'] ??
                    itemMap['salePrice'] ??
                    itemMap['fullPrice'] ??
                    itemMap['productTotalPrice'],
              );
              final int qty = _parseQuantity(
                  itemMap['quantity'] ?? itemMap['productQuantity']);
              final String? image = _extractItemImage(itemMap);

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: SizedBox(
                    width: 48,
                    height: 48,
                    child: image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, _, __) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.image_outlined),
                          ),
                  ),
                  title: Text(name),
                  subtitle: Text(
                    'Price: PKR ${itemPrice.toStringAsFixed(0)}\nQty: $qty',
                  ),
                  isThreeLine: true,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
