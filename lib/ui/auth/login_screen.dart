import 'package:firebase_asif_taj_tutorials/posts/add_post.dart';
import 'package:firebase_asif_taj_tutorials/posts/posts_screen.dart';
import 'package:firebase_asif_taj_tutorials/ui/auth/signup_screen.dart';
import 'package:firebase_asif_taj_tutorials/ui/widgets/round_button.dart';
import 'package:firebase_asif_taj_tutorials/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _loginAuth = FirebaseAuth.instance;
  bool loading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('Login'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                RoundButton(
                  loading: loading,
                  title: 'Login',
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text('Forgot Password?'),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                        debugPrint(
                            '===================================================Navigating to signup_screen.dart');
                      },
                      child: Text('Sing up'),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // InkWell(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => LoginWithPhoneNumber(),
                //       ),
                //     );
                //   },
                //   child: Container(
                //     height: 50,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(50),
                //       border: Border.all(color: Colors.black)
                //     ),
                //     child: Center(child: Text('Login With Phone Number'))
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    setState(() {
      loading = true;
    });
    _loginAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((value) {
      Utils().showToastMessage(value.user!.email.toString());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PostScreen(),
        ),
      );
      debugPrint(
          '===================================================Navigating to posts_screen.dart');

      setState(() {
        loading = false;
      });
      debugPrint(
          'login_screen.dart--------------------------------------------------------User signed in successfully: ${value.user!.email}');
    }).onError((error, stackTrace) {
      Utils().showToastMessage(error.toString());
      setState(() {
        loading = false;
      });
      debugPrint(
          'login_screen.dart-----------------------------------------------------------User sign in error: $error');
    });
  }
}
