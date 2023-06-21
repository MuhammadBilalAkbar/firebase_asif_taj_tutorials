import 'dart:async';

import 'package:firebase_asif_taj_tutorials/posts/posts_screen.dart';
import 'package:firebase_asif_taj_tutorials/ui/auth/login_screen.dart';
import 'package:firebase_asif_taj_tutorials/ui/firestore/firestore_list_screen.dart';
import 'package:firebase_asif_taj_tutorials/ui/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {

  void isLogin(BuildContext context) {
    final FirebaseAuth checkIfLogin = FirebaseAuth.instance;
    final _userDetail = checkIfLogin.currentUser;

    if (_userDetail != null) {
      debugPrint('splash_services.dart-------------------------------------------------------User already logged in. User email: ${_userDetail.email}');
      Timer(
        Duration(seconds: 3),
            () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PostScreen(),
              // builder: (context) => UploadImageScreen(),
            ),
          );
          // debugPrint('===================================================Navigating to posts_screen.dart');
          debugPrint('===================================================Navigating to firestore_list_screen.dart');
          debugPrint('===================================================Navigating to upload_image_screen.dart');
        },
      );
    } else {
      Timer(
        Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
          debugPrint('===================================================Navigating to login_screen.dart');

        },
      );
    }
  }
}
