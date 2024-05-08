import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:flutter_application_1/components/like_button.dart";
import "package:firebase_auth/firebase_auth.dart";

class WallPost extends StatefulWidget{
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

  //user
  final user = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  //text controller for comment
  final _commentController = TextEditingController();

  @override
  void initState(){
    super.initState();
    isLiked = widget.likes.contains(user.email);
  }

  //toggle like
  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });

    //Access the document is firebase
    DocumentReference postRef = FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if(isLiked){
      //if the post is now liked , add the user's email to the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayUnion([user.email]),
      });
    } else{
      //if the post is now unliked, remove the user's email from the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayRemove([user.email]),
      });
    }
  }

  //add a comment
  void addComment(String commentText){
    //write the comment to firestore  under the comments collection for this post
    FirebaseFirestore.instance
    .collection("User Posts")
    .doc(widget.postId)
    .collection("Comments")
    .add({
      'CommentText': commentText,
      'CommentedBy': user.email,
      'CommentTime': Timestamp.now(), //remember to format this when displaying
    });
  }

  //show a dialog box for adding comment
  void showCommentDialog(BuildContext context){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text("Add a comment"),
        content: TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: "Enter your comment here",
          ),
        ),
        actions:[
          // Post buttton
          TextButton(
            onPressed: () => addComment(_commentController.text), 
            child: Text("Post"),
            ),

          //cancel button
           TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text("Cancel"),
            ),
        ],
      ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //message and user email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[500]),
                ),
                const SizedBox(height: 10,),
              Text(widget.message),
            ],
          ),
                    const SizedBox(width: 20),
          //buttons
          Row(children: [
            Column(
            children: [
            //LIKE
              //like button
              LikeButton(
                isLiked: isLiked, 
                onTap: toggleLike,
                ),

              const SizedBox(height: 5,),

              //like count
              Text(widget.likes.length.toString(),
              style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          //COMMENT
          Column(
            children: [
            //LIKE
              //comment button
              LikeButton(
                isLiked: isLiked, 
                onTap: toggleLike,
                ),

              const SizedBox(height: 5,),

              //like count
              Text(widget.likes.length.toString(),
              style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          ],
          ),
        ],
      ),
    );
  }
}