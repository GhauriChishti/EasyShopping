// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerDeviceToken,
}) async {
  if (customerName.isEmpty ||
      customerPhone.isEmpty ||
      customerAddress.isEmpty ||
      customerDeviceToken.isEmpty) {
    Get.snackbar('Error', 'Missing order details');
    return;
  }

  Get.snackbar('Success', 'Order request submitted');
}
