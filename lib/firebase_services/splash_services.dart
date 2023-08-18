import 'dart:async';

import 'package:firebase_asif_taj_tutorials/posts/posts_screen.dart';
import 'package:firebase_asif_taj_tutorials/ui/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final FirebaseAuth checkIfLogin = FirebaseAuth.instance;
    final userDetail = checkIfLogin.currentUser;

    if (userDetail != null) {
      debugPrint(
          'splash_services.dart-------------------------------------------------------User already logged in. User email: ${userDetail.email}');
      Timer(
        const Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PostScreen(),
              // builder: (context) => UploadImageScreen(),
            ),
          );
          // debugPrint('===================================================Navigating to posts_screen.dart');
          debugPrint(
              '===================================================Navigating to firestore_list_screen.dart');
          debugPrint(
              '===================================================Navigating to upload_image_screen.dart');
        },
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
          debugPrint(
              '===================================================Navigating to login_screen.dart');
        },
      );
    }
  }
}
