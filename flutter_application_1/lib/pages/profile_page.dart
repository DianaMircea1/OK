import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_application_1/components/text_box.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //user 
  final currentuser= FirebaseAuth.instance.currentUser!;

  //all users
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  //edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(68, 35, 72, 1),
        title: Text("Edit $field", style: const TextStyle(color: Color.fromRGBO(246, 239, 248, 1)),
        ),
        content:  TextField(
          autofocus: true, 
          style: const TextStyle(color: Color.fromRGBO(246, 239, 248,1)),
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            hintStyle: const TextStyle(color: Color.fromRGBO(246, 239, 248,1)),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          //cancel button
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(color: Color.fromRGBO(246, 239, 248,1)),
            ),
            onPressed: () => Navigator.pop(context),
            ),

          //save button
          TextButton(
            child: const Text(
              "Save",
              style: TextStyle(color: Color.fromRGBO(246, 239, 248,1)),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
            ),
        ],
      )
      );
      //update in firestore
      if(newValue.trim().isNotEmpty){
         await usersCollection.doc(currentuser.email).update({field: newValue});
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 248, 252, 1),
      appBar: AppBar(
        title: const Text("Profile Page",
        style: TextStyle(color: Color.fromRGBO(68, 35, 72, 1)),
        ),
        backgroundColor: const Color.fromRGBO(246, 239, 248, 1),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("Users").doc(currentuser.email).snapshots(),  
          builder: (context, snapshot) {
            //get user data
            if(snapshot.hasData){
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
            children: [
            const SizedBox(height: 40),
            //profile pic
            const Icon(
              Icons.person_pin,
              size: 100,
              color: Color.fromRGBO(121, 74, 127, 1),
            ),
            const SizedBox(height: 5),
            //user email
            Text(
              currentuser.email!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color.fromRGBO(121, 74, 127, 1),
              fontSize: 20,
              ),
              ),
            const SizedBox(height: 50),

            //user details
            const Padding(
              padding:  EdgeInsets.only(left: 25.0),
              child: Text(
                "My Details", 
                style: TextStyle(color:  Color.fromRGBO(68, 35, 72, 1),
                fontSize: 18,
                ),
              ),
            ),

            //username
            MyTextBox(
              text: userData["username"], 
              sectionName: "Username",
              onPressed: () => editField("username"),
              ),
            //bio 
            MyTextBox(
              text: userData["bio"],
              sectionName: "Bio",
              onPressed: () => editField("bio"),
              ),
              const SizedBox(height: 50),
            //user posts
            /*const Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                "My Posts", 
                style: TextStyle(color: Color.fromRGBO(68, 35, 72, 1)
                ),
              ),
            ),*/
          ],
        );
            }else if (snapshot.hasError){
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
    );
  }
}