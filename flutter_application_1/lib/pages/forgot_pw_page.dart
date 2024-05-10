import "package:firebase_auth/firebase_auth.dart";
// ignore: unnecessary_import
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_application_1/components/my_textfield.dart";

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // text editing controllers
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // password reset method
  Future passwordReset() async {
    try{
      await FirebaseAuth.instance
    .sendPasswordResetEmail(email: emailController.text.trim());
    showDialog(
        // ignore: use_build_context_synchronously
        context: context, 
        builder: (context) {
          return const AlertDialog(
            content: Text("Password reset link sent! Check your email"),
          );

        }
        );
    
    }on FirebaseAuthException catch (e){
      // ignore: avoid_print
      print(e);
      showDialog(
        // ignore: use_build_context_synchronously
        context: context, 
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );

        }
        );
    }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromRGBO(251, 248, 252, 1),
      appBar: AppBar(
        title: const Text("Reset Password",
        style: TextStyle(
          color: Color.fromRGBO(68, 35, 72, 1),
          fontSize: 20,
          fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(246, 239, 248, 1),
        ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           const Text(
            "Enter your email to reset your password",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(68, 35, 72, 1),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
            const SizedBox(height: 20),
          MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
              MaterialButton(
              onPressed: passwordReset,
              color: const Color.fromRGBO(68, 35, 72, 1),
              child: const Text("Reset Password",
              style: TextStyle(
                color: Color.fromRGBO(246, 239, 248, 1),
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
              )
              )
        ],
      )

    );
  }
}