import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/button.dart';
import 'package:thewall/components/text_field.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  //sign user in
  void signIn() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.grey),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);

      //pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //display error message
      Get.snackbar(
        'Oops!', e.code,
        colorText: Theme.of(context).colorScheme.primary,
        snackPosition: SnackPosition.TOP,
        maxWidth: Get.width,
        borderRadius: 10,
        duration: const Duration(milliseconds: 2200),
        barBlur: 0,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        icon: Icon(Icons.error, color: Theme.of(context).colorScheme.primary),
      );
    }
  }

  //display a dialog message
  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 100, color: Theme.of(context).colorScheme.primary,),
                const SizedBox(height: 50),

                //welcome msg
                Text(
                  "Welcome Back, you've been missed!",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                //text
                const SizedBox(height: 25),

                MyTextField(
                    controller: emailTextController,
                    hintText: "Email",
                    obsecureText: false),

                const SizedBox(height: 25),

                MyTextField(
                    controller: passwordTextController,
                    hintText: "Password",
                    obsecureText: true),

                const SizedBox(height: 25),

                MyButton(onTap: signIn, text: "Sign in"),

                const SizedBox(height: 25),

                //go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
