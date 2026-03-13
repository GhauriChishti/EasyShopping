// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  double _parsePrice(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appMainColor,
          title: const Text('Cart'),
        ),
        body: const Center(
          child: Text('Please sign in to view your cart.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text('Cart'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .orderBy('addedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong while loading cart.'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text('Your cart is empty.'),
            );
          }

          double totalPrice = 0;
          for (final doc in docs) {
            final data = doc.data();
            final double price = _parsePrice(data['price']);
            final int quantity = (data['quantity'] as num?)?.toInt() ?? 0;
            totalPrice += price * quantity;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final String name =
                        (data['name'] ?? 'Product').toString().trim().isEmpty
                            ? 'Product'
                            : data['name'].toString();
                    final String imageUrl = (data['imageUrl'] ?? '').toString();
                    final double price = _parsePrice(data['price']);
                    final int quantity =
                        (data['quantity'] as num?)?.toInt() ?? 1;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageUrl.isEmpty
                              ? Container(
                                  color: Colors.grey.shade200,
                                  width: 52,
                                  height: 52,
                                  child: const Icon(Icons.image_not_supported),
                                )
                              : Image.network(
                                  imageUrl,
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade200,
                                    width: 52,
                                    height: 52,
                                    child: const Icon(Icons.broken_image),
                                  ),
                                ),
                        ),
                        title: Text(name),
                        subtitle: Text(
                          'PKR ${price.toStringAsFixed(0)}  •  Qty: $quantity',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .collection('cart')
                                .doc(docs[index].id)
                                .delete();

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Item removed from cart'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'PKR ${totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstant.appMainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
