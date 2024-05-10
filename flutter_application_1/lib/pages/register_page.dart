
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_textfield.dart';
class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController= TextEditingController();

  // sign user in method
  void signUserUp() async {
    //show loading circle 
    showDialog(
    context: context, 
    builder: (context) => const Center(child: CircularProgressIndicator(),)
    );
    
    //make sure passwords match 
    if(passwordController.text != confirmPasswordController.text){
      //pop loading circle
      Navigator.pop(context);
      //show error to user 
      showErrorMessage("Passwords do not match!");
      return;
    }
    //try creating the user
    try{

      //create user 
      UserCredential userCredential = 
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text);

        //after creating user, create new document in the firebase
        FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential.user!.email)
        .set({
          'username': emailController.text.split('@')[0], //initial username
          'bio': 'Empty bio', //initial bio
          //add more fields here
        });

    //pop loading circle
    // ignore: use_build_context_synchronously
    if(context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch(e){
      //pop loading circle
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      //show error to user 
      showErrorMessage(e.code);
    }
  }
  //error message to user
 void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 248, 252, 1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
            
                // logo
                const Icon(
                  Icons.supervisor_account_sharp,
                  size: 100,
                  color: Color.fromRGBO(121, 74, 127, 1),
                ),
            
                const SizedBox(height: 25),
            
                // let's create an account for you
                const Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(
                    color: Color.fromRGBO(68, 35, 72, 1),
                    fontSize: 16,
                  ),
                ),
            
                const SizedBox(height: 25),
            
                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
            
                const SizedBox(height: 10),
            
                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                // confirm password textfield
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 50),
            
                // sign in button
                MyButton(
                  text: 'Sign Up',
                  onTap: signUserUp,
                ),
            
                const SizedBox(height: 50),
            
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Color.fromRGBO(68, 35, 72, 1)),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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