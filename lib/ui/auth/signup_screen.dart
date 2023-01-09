import 'package:firebase_asif_taj_tutorials/posts/posts_screen.dart';
import 'package:firebase_asif_taj_tutorials/ui/auth/login_screen.dart';
import 'package:firebase_asif_taj_tutorials/ui/widgets/round_button.dart';
import 'package:firebase_asif_taj_tutorials/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _signUpAuth = FirebaseAuth.instance;
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Sign Up'),
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
                title: 'Sign Up',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    signUp();
                  }
                },
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Aleready have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                      debugPrint(
                          '===================================================Navigating to login_screen.dart');
                    },
                    child: Text('Login'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUp() {
    setState(() {
      loading = true;
    });
    _signUpAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((value) {
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PostScreen(),
        ),
      );
      debugPrint('===================================================Navigating to posts_screen.dart');
      debugPrint(
          'signup_screen.dart-------------------------------------------------------------------User registered successfully: ${value.user!.email}');
    }).onError((error, stackTrace) {
      Utils().showToastMessage(error.toString());
      setState(() {
        loading = false;
      });
      debugPrint(
          'signup_screen.dart-------------------------------------------------------------------User registration error: $error');
    });
  }
}
