import 'package:firebase_asif_taj_tutorials/ui/widgets/round_button.dart';
import 'package:firebase_asif_taj_tutorials/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool empty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Forgot Password',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
              SizedBox(height: 30),
              RoundButton(title: 'Forgot', onTap: () {
                auth.sendPasswordResetEmail(email: emailController.text.trim()).then((value) {
                  Utils().showToastMessage('We have sent you an email to recover password, please check your email inbox');
                }).onError((error, stackTrace) {
                  Utils().showToastMessage(error.toString());
                });
              })
            ],
          ),
        ),);
  }
}
