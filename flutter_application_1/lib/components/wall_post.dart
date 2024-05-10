
import "package:cloud_firestore/cloud_firestore.dart";
// ignore: unused_import
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_application_1/components/comment_button.dart";
import "package:flutter_application_1/components/comments.dart";
import "package:flutter_application_1/components/delete_button.dart";
import "package:flutter_application_1/components/like_button.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_application_1/helper/helper_methods.dart";

class WallPost extends StatefulWidget{
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
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
        backgroundColor: const Color.fromRGBO(68, 35, 72, 1),
        title: const Text("Add a comment",
        style: TextStyle(color: Color.fromRGBO(246, 239, 248, 1)),
        ),
        content: TextField(
          controller: _commentController,
          decoration: const InputDecoration(
            hintText: "Enter your comment here",
            hintStyle: TextStyle(color: Color.fromRGBO(246, 239, 248, 1)),
          ),
        ),
        actions:[
          //cancel button
           TextButton(
            onPressed: () {
              //pop box
              Navigator.pop(context);

              //clear the text field
              _commentController.clear();
            }, 
            child: const Text("Cancel",
            style: TextStyle(color: Color.fromRGBO(246, 239, 248, 1)),
            ),
            ),

            // Post buttton
          TextButton(
            onPressed: () {
              //add the comment
              addComment(_commentController.text);

              //pop the box
              Navigator.pop(context);

              //clear the controller
              _commentController.clear();
            }, 
            child: const Text("Post",
            style: TextStyle(color: Color.fromRGBO(246, 239, 248, 1)),
            ),
            ),

        ],
      ),
      );
  }

  //delete a post 
  void deletePost(){
    //show a dialog post to confirm before deleting
    showDialog(
    context: context, 
    builder: (context)=> AlertDialog(
      backgroundColor: const Color.fromRGBO(68, 35, 72, 1),
      title: const Text("Delete Post",
      style: TextStyle(color: Color.fromRGBO(246, 239, 248, 1)),
      ),
      content: const Text("Are you sure you want to delete this post?",
      style: TextStyle(color: Color.fromRGBO(246, 239, 248, 1)),
      ),
      actions: [
        //cancel button
        TextButton(
        onPressed: () => Navigator.pop(context), 
        child: const Text ("Cancel",
        style: TextStyle(color: Color.fromRGBO(246, 239, 248, 1)),
        ),
        ),

        //delete button
        TextButton(
        onPressed: () async {
          //delete the comments from the firestore first 
          //(if you only delete the post, the comments will still be stored in the firestore)
          final commentDocs = await FirebaseFirestore.instance
            .collection("User Posts")
            .doc(widget.postId)
            .collection("Comments")
            .get();
          for (var doc in commentDocs.docs){
            await FirebaseFirestore.instance
              .collection("User Posts")
              .doc(widget.postId)
              .collection("Comments")
              .doc(doc.id)
              .delete();
          }

          //delete the post
          FirebaseFirestore.instance
            .collection("User Posts")
            .doc(widget.postId)
            // ignore: avoid_print
            .delete().then((value) => print('Post Deleted'))
            // ignore: avoid_print
            .catchError((error) => print('Failed to delete post: $error'));

            //dismiss the dialog box 
            // ignore: use_build_context_synchronously
            Navigator.pop(context);

        }, 
        child: const Text ("Delete",
        style: TextStyle(color: Color.fromRGBO(246, 239, 248, 1)),
        ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(239, 226, 242, 1),
        borderRadius: BorderRadius.circular(8),
        ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //wallpost
        children: [
          //message and user email
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //group of text 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //message
                  Text(widget.message,
                  style: const TextStyle(color: Color.fromRGBO(68, 35, 72, 1)),
                  ),
              
                  const SizedBox(height: 5),
              
                  //user
                  Row(
                children: [
                  Text(
                    widget.user,
                    style: const TextStyle(color: Color.fromRGBO(98, 60, 103, 1)),
                  ),
                  const Text(
                    " - ",
                    style: TextStyle(color:Color.fromRGBO(98, 60, 103, 1)),
                    ),
                  Text(
                    widget.time,
                    style: const TextStyle(color: Color.fromRGBO(98, 60, 103, 1)),
                    ),
                ],
              ),
                ],
              ),
              //delete button 
              if(widget.user == user.email)
              DeleteButton(onTap: deletePost,
                
              )
            ],
          ),

            const SizedBox(width: 20),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              style: const TextStyle(color: Color.fromRGBO(121, 74, 127, 1)),
              ),
            ],
          ),

          const SizedBox(width: 10,),
          //COMMENT
          Column(
            children: [
              //comment button
              CommentButton(onTap: () => showCommentDialog(context)),

              const SizedBox(height: 5,),
            ],
          ),
          ],
          ),

          const SizedBox(height: 20),

          //comments under the post 
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
              .collection("User Posts")
              .doc(widget.postId)
              .collection("Comments")
              .orderBy("CommentTime", descending: true)
              .snapshots(),
            builder: (context, snapshot)
            {
              //showloading circle if no data yet
              if(!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                shrinkWrap: true, //for nested lists
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  //get the comment from firebase
                  final commentData = doc.data() as Map<String, dynamic>;

                  //return the comment in our UI
                  return Comment(
                    text: commentData['CommentText'], 
                    user: commentData['CommentedBy'], 
                    time: formatDate(commentData['CommentTime']),
                    );
                },).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}