import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_project/model/post.dart';
import 'package:test_flutter_project/model/user.dart';
import 'package:test_flutter_project/screens/imagePost.dart';
import 'package:test_flutter_project/services/auth.dart';
import 'package:test_flutter_project/services/database.dart';

class PhotoTapePage extends StatefulWidget {
  PhotoTapePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PhotoTapePageState();
}

class PhotoTapePageState extends State<PhotoTapePage>
    with AutomaticKeepAliveClientMixin<PhotoTapePage> {
  LocalUser user;
  List<Post> posts;
  List<ImagePost> feedData;

  buildFeed() {
    if (feedData != null) {
      return ListView(
        children: feedData.reversed.toList(),
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<LocalUser>(context);
    _getFeed();
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
                  icon: Icon(Icons.refresh, color: Colors.black),
                  onPressed: _refresh),
        title: const Text('ARCHTR',
            style: const TextStyle(
                fontFamily: "Billabong", color: Colors.black, fontSize: 35.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: buildFeed(),
      ),
    );
  }

  Future<Null> _refresh() async {
    await _getFeed();

    setState(() {});

    return;
  }

  _getFeed() async {
    List<ImagePost> listOfPosts;
    posts = await DataBaseService().getPosts();
    LocalUser userFromDb = await DataBaseService().getUser(user.id);
    listOfPosts = _generateFeed(posts, userFromDb);
    setState(() {
      feedData = listOfPosts;
    });
  }

  List<ImagePost> _generateFeed(List<Post> posts, userFromDb) {
    List<ImagePost> listOfPosts = [];

    for (var post in posts) {
      listOfPosts.add(ImagePost.fromPost(post, userFromDb));
    }

    return listOfPosts;
  }

  @override
  bool get wantKeepAlive => true;
}

// ignore: must_be_immutable
class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String
      userId; // types include liked photo, follow user, comment on photo
  final String mediaUrl;
  final String mediaId;

  ActivityFeedItem({this.username, this.userId, this.mediaUrl, this.mediaId});

  factory ActivityFeedItem.fromPost(Post post, LocalUser user) {
    return ActivityFeedItem(
      username: user.name,
      userId: user.id,
      mediaUrl: post.mediaUrl,
      mediaId: post.id,
    );
  }

  Widget mediaPreview = Container();
  String actionText = "actionText";

  void configureItem(BuildContext context) {
    mediaPreview = GestureDetector(
      child: Container(
        height: 45.0,
        width: 45.0,
        child: AspectRatio(
          aspectRatio: 487 / 451,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              alignment: FractionalOffset.topCenter,
              image: NetworkImage(mediaUrl),
            )),
          ),
        ),
      ),
    );

    // if (type == "like") {
    //   actionText = " liked your post.";
    // } else if (type == "follow") {
    //   actionText = " starting following you.";
    // } else if (type == "comment") {
    //   actionText = " commented: $commentData";
    // } else {
    //   actionText = "Error - invalid activityFeed type: $type";
    // }
  }

  @override
  Widget build(BuildContext context) {
    configureItem(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archtr',
            style: const TextStyle(
                fontFamily: "Billabong", color: Colors.black, fontSize: 35.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Image.network(mediaUrl),
      // mainAxisSize: MainAxisSize.max,
      // children: <Widget>[
      //   Expanded(
      //     child: Row(
      //       mainAxisSize: MainAxisSize.min,
      //       children: <Widget>[
      //         GestureDetector(
      //           child: Text(
      //             username,
      //             style: TextStyle(fontWeight: FontWeight.bold),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      //   Container(
      //     decoration: BoxDecoration(
      //         image: DecorationImage(
      //           fit: BoxFit.fill,
      //           alignment: FractionalOffset.topCenter,
      //           image: NetworkImage(mediaUrl),
      //         )),
      //   )
      // ],
    );
  }
}
