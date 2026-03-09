// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_comm/controllers/get-device-token-controller.dart';
import 'package:e_comm/models/user-model.dart';
import 'package:e_comm/screens/user-panel/main-screen.dart';
import 'package:e_comm/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    final GetDeviceTokenController getDeviceTokenController =
        Get.put(GetDeviceTokenController());

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        Get.snackbar(
          "Cancelled",
          "Google sign-in was cancelled.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appScendoryColor,
          colorText: AppConstant.appTextColor,
        );
        return;
      }

      EasyLoading.show(status: "Please wait..");

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          "Google sign-in failed. No user returned.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppConstant.appScendoryColor,
          colorText: AppConstant.appTextColor,
        );
        return;
      }

      final userModel = UserModel(
        uId: user.uid,
        username: user.displayName ?? '',
        email: user.email ?? '',
        phone: user.phoneNumber ?? '',
        userImg: user.photoURL ?? '',
        userDeviceToken: getDeviceTokenController.deviceToken?.toString() ?? '',
        country: '',
        userAddress: '',
        street: '',
        isAdmin: false,
        isActive: true,
        createdOn: DateTime.now(),
        city: '',
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userModel.toMap(), SetOptions(merge: true));

      EasyLoading.dismiss();
      Get.offAll(() => const MainScreen());
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Google Sign-In Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appScendoryColor,
        colorText: AppConstant.appTextColor,
        duration: const Duration(seconds: 6),
      );
    }
  }
}
