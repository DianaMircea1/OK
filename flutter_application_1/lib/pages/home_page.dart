import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/drawer.dart';
import 'package:flutter_application_1/components/my_textfield.dart';
import 'package:flutter_application_1/components/wall_post.dart';
import 'package:flutter_application_1/helper/helper_methods.dart';
import 'package:flutter_application_1/pages/profile_page.dart';

class HomePage extends StatefulWidget{
   const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // user
  final user =FirebaseAuth.instance.currentUser!;
  // text controller
  final textController = TextEditingController();

  //sing out method 
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  //post message method
  void postMessage(){
    //only post if the text field is not empty
    if(textController.text.isNotEmpty){
      //store in firebase 
      FirebaseFirestore.instance.collection("User Posts").add(
        {
          'UserEmail': user.email,
          'Message': textController.text,
          'Timestamp': Timestamp.now(),
          'Likes': [],
        }
      );
    }
    //clear the text field
    setState(() {
      textController.clear();
    });
  }

  //go to profile page
  void gotoProfilePage(){
    //pop menu drawer 
    Navigator.pop(context);
    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 248, 252, 1),
      appBar: AppBar(
        title: const Text(
          "Wink",
          textAlign: TextAlign.center,
          style: TextStyle(
          color: Color.fromRGBO(68, 35, 72, 1),
          fontSize: 40,
          fontWeight: FontWeight.bold,
          textBaseline: TextBaseline.alphabetic

          ),
        ),
        backgroundColor: const Color.fromRGBO(246, 239, 248, 1),
        centerTitle: true,
        ),
        drawer: MyDrawer(
          onProfileTap: gotoProfilePage,
          onSignOut: signUserOut,
        ),
      body:Center(
        child: Column(
          children: [
            //wink
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                .collection("User Posts")
                .orderBy(
                  "Timestamp", 
                  descending: false,
                  )
                  .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          //get the message
                          final post = snapshot.data!.docs[index];
                          return WallPost(
                            message: post["Message"], 
                            user: post["UserEmail"],
                            postId: post.id,
                            likes: List<String>.from(post["Likes"] ?? []),
                            time: formatDate(post["Timestamp"]),
                          );
                        },
                      );
                    } else if(snapshot.hasError){
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
              ),
            ),
        
            //post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: "Write something on Wink...",
                      obscureText: false,
                    ),
                  ),
                  //post button
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(
                      Icons.arrow_circle_up_rounded,
                      color: Color.fromRGBO(121, 74, 127, 1),
                    )
                  ),
                ],
              ),
            ),
        
            //logged in as
             Text(
              "Logged in as:${user.email!}",
              style: const TextStyle(color: Color.fromRGBO(208, 168, 216, 1)),),
              const SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}