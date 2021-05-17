import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_project/model/post.dart';
import 'package:test_flutter_project/model/user.dart';
import 'package:test_flutter_project/services/database.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';

class ImagePost extends StatefulWidget {
  const ImagePost(
      {this.mediaUrl,
        this.username,
        // this.location,
        // this.description,
        this.likes,
        this.postId,
        this.ownerId});

  factory ImagePost.fromDocument(DocumentSnapshot document) {
    return ImagePost(
      // username: document['username'],
      // location: document['location'],
      mediaUrl: document['mediaUrl'],
      likes: document['likes'],
      // description: document['description'],
      postId: document.id,
      ownerId: document['userId'],
    );
  }

  factory ImagePost.fromPost(Post post, LocalUser user) {
    return ImagePost(
      username: user.name,
      // location: data['location'],
      mediaUrl: post.mediaUrl,
      likes: post.likes,
      // description: data['description'],
      ownerId: post.userId,
      postId: post.id,
    );
  }

  int getLikeCount(var likes) {
    if (likes == null) {
      return 0;
    }
// issue is below
    var vals = likes.values;
    int count = 0;
    for (var val in vals) {
      if (val == true) {
        count = count + 1;
      }
    }

    return count;
  }

  final String mediaUrl;
  final String username;
  // final String location;
  // final String description;
  final likes;
  final String postId;
  final String ownerId;

  _ImagePost createState() => _ImagePost(
    mediaUrl: this.mediaUrl,
    username: this.username,
    // location: this.location,
    // description: this.description,
    likes: this.likes,
    likeCount: getLikeCount(this.likes),
    ownerId: this.ownerId,
    postId: this.postId,
  );
}

class _ImagePost extends State<ImagePost> {
  final String mediaUrl;
  final String username;
  // final String location;
  // final String description;
  Map likes;
  int likeCount;
  final String postId;
  bool liked;
  final String ownerId;

  bool showHeart = false;

  TextStyle boldStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  var reference = FirebaseFirestore.instance.collection('posts');
  LocalUser user;

  _ImagePost(
      {this.mediaUrl,
        this.username,
        // this.location,
        // this.description,
        this.likes,
        this.postId,
        this.likeCount,
        this.ownerId});

  GestureDetector buildLikeIcon() {
    Color color;
    IconData icon;

    if (liked) {
      color = Colors.pink;
      icon = FontAwesomeIcons.solidHeart;
    } else {
      icon = FontAwesomeIcons.heart;
    }
    icon = FontAwesomeIcons.heart;
    return GestureDetector(
        child: Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          _likePost(postId);
        });
  }

  GestureDetector buildLikeableImage() {
    return GestureDetector(
      onDoubleTap: () => _likePost(postId),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: mediaUrl,
            fit: BoxFit.fitWidth,
            placeholder: (context, url) => loadingPlaceHolder,
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          showHeart
              ?
          Positioned(
            child: Container(
              width: 100,
              height: 100,
              child:  Opacity(
                  opacity: 0.85,
                  child: FlareActor("assets/flare/Like.flr",
                    animation: "Like",
                  )),
            ),
          )
              : Container()
        ],
      ),
    );
  }

  buildPostHeader({String ownerId}) {
    if (ownerId == null) {
      return Text("owner error");
    }

    return FutureBuilder(
        future: DataBaseService().getUser(ownerId),
        builder: (context, snapshot) {

          if (snapshot.data != null) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(snapshot.data.photoUrl),
                backgroundColor: Colors.grey,
              ),
              title: GestureDetector(
                child: Text(snapshot.data.name, style: boldStyle),
                // child: Text("Username", style: boldStyle),
                // onTap: () {
                //   openProfile(context, ownerId);
                // },
              ),
              // subtitle: Text('subtitleText'),
            );
          }
          return Container();
        });
  }

  Container loadingPlaceHolder = Container(
    height: 400.0,
    child: Center(child: CircularProgressIndicator()),
  );

  @override
  Widget build(BuildContext context) {
    user = Provider.of<LocalUser>(context);
    liked = (likes[user.id] == true);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(ownerId: ownerId),
        buildLikeableImage(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
            buildLikeIcon(),
            Padding(padding: const EdgeInsets.only(right: 5.0)),
            Container(
              margin: const EdgeInsets.only(left: 5.0),
              child: Text(
                "$likeCount likes",
                style: boldStyle,
              ),
            )
            // GestureDetector(
            //     child: const Icon(
            //       Icons.comment,
            //       size: 25.0,
            //     ),
            //     // onTap: () {
            //     //   goToComments(
            //     //       context: context,
            //     //       postId: postId,
            //     //       ownerId: ownerId,
            //     //       mediaUrl: mediaUrl);
            //     // }
            //     ),
          ],
        ),
        // Row(
        //   children: <Widget>[
        //     Container(
        //       margin: const EdgeInsets.only(left: 20.0),
        //       child: Text(
        //         "13 likes",
        //         // "$likeCount likes",
        //         style: boldStyle,
        //       ),
        //     )
        //   ],
        // ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Container(
        //         margin: const EdgeInsets.only(left: 20.0),
        //         child: Text(
        //           "$username ",
        //           style: boldStyle,
        //         )),
        //     Expanded(child: Text("description")),
        //   ],
        // )
      ],
    );
  }

  void _likePost(String postId2) {
    var userId = user.id;
    bool _liked = likes[userId] == true;

    if (_liked) {
      print('removing like');
      reference.doc(postId).update({
        'likes.$userId': false
      });

      setState(() {
        likeCount = likeCount - 1;
        liked = false;
        likes[userId] = false;
      });

      // removeActivityFeedItem();
    }

    if (!_liked) {
      print('liking');
      setState(() {
        likeCount = likeCount + 1;
        liked = true;
        likes[userId] = true;
        showHeart = true;
      });
      Timer(const Duration(milliseconds: 2000), () {
        setState(() {
          showHeart = false;
        });
      });
      reference.doc(postId).update({'likes.$userId': true});

    }
  }

  // void addActivityFeedItem() {
  //   FirebaseFirestore.instance
  //       .collection("insta_a_feed")
  //       .doc(ownerId)
  //       .collection("items")
  //       .doc(postId)
  //       .set({
  //     "username": currentUserModel.username,
  //     "userId": currentUserModel.id,
  //     "type": "like",
  //     "userProfileImg": currentUserModel.photoUrl,
  //     "mediaUrl": mediaUrl,
  //     "timestamp": DateTime.now(),
  //     "postId": postId,
  //   });
  // }

  void removeActivityFeedItem() {
    FirebaseFirestore.instance
        .collection("insta_a_feed")
        .doc(ownerId)
        .collection("items")
        .doc(postId)
        .delete();
  }
}

// class ImagePostFromId extends StatelessWidget {
//   final String id;
//
//   const ImagePostFromId({this.id});
//
//   getImagePost() async {
//     var document =
//     await FirebaseFirestore.instance.collection('insta_posts').doc(id).get();
//     return ImagePost.fromDocument(document);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getImagePost(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData)
//             return Container(
//                 alignment: FractionalOffset.center,
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: CircularProgressIndicator());
//           return snapshot.data;
//         });
//   }
// }
//
// void goToComments(
//     {BuildContext context, String postId, String ownerId, String mediaUrl}) {
//   Navigator.of(context)
//       .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
//     return CommentScreen(
//       postId: postId,
//       postOwner: ownerId,
//       postMediaUrl: mediaUrl,
//     );
//   }));
// }
