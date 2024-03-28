import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thewall/components/button.dart';
import 'package:thewall/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  //sign user up
  void signUp() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    //make sure password match
    if (passwordTextController.text != confirmPasswordTextController.text) {
      //pop the loading circle
      Navigator.pop(context);
      //show error to user
      Get.snackbar(
        'Oops!', "Password don't match!",
        colorText: Theme.of(context).colorScheme.primary,
        snackPosition: SnackPosition.BOTTOM,
        maxWidth: Get.width,
        borderRadius: 10,
        duration: const Duration(milliseconds: 2200),
        barBlur: 0,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        icon: Icon(Icons.error, color: Theme.of(context).colorScheme.primary),
      );
      return;
    }

    //try creating a user
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text);

      //after creating a user, create a new Document in cloud firestore 'Users'
      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'username': emailTextController.text.split('@')[0],
        'bio': 'Empty bio...' //initally empty bio
      });

      //pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //show error to user
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 100,
                  color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 50),

                  //welcome msg
                  Text(
                    "Let's create an account for you!",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  //text
                  const SizedBox(height: 25),
                  //email
                  MyTextField(
                      controller: emailTextController,
                      hintText: "Email",
                      obsecureText: false),

                  const SizedBox(height: 25),

                  //password
                  MyTextField(
                      controller: passwordTextController,
                      hintText: "Password",
                      obsecureText: true),

                  const SizedBox(height: 25),

                  //confirm password
                  MyTextField(
                      controller: confirmPasswordTextController,
                      hintText: "Confrim Password",
                      obsecureText: true),

                  const SizedBox(height: 25),

                  //sign up buttton
                  MyButton(onTap: signUp, text: "Sign Up"),

                  const SizedBox(height: 25),

                  //go to register page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login here",
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
      ),
    );
  }
}
