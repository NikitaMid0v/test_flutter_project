import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_project/model/post.dart';
import 'package:test_flutter_project/model/user.dart';
import 'package:test_flutter_project/services/database.dart';
import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  UploadPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => UploadPageState();
}

class UploadPageState extends State<UploadPage> {
  File file;
  ImagePicker imagePicker = ImagePicker();
  bool uploading = false;
  LocalUser user;

  Widget build(BuildContext context) {
    user = Provider.of<LocalUser>(context);

    return file == null
        ? Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 330),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                splashColor: Theme.of(context).primaryColor,
                highlightColor: Theme.of(context).primaryColor,
                color: Colors.red,
                child: Text("CREATE NEW POST",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                onPressed: () => {_selectImage(context)},
              ),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white70,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: clearImage),
              title: const Text(
                'Post to',
                style: const TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: postImage,
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ))
              ],
            ),
            body: ListView(
              children: <Widget>[
                PostForm(
                  imageFile: file,
                  loading: uploading,
                ),
                // RaisedButton(
                //   splashColor: Theme.of(context).primaryColor,
                //   highlightColor: Theme.of(context).primaryColor,
                //   color: Colors.red,
                //   child: Text("POST",
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, color: Colors.white)),
                //   onPressed: () => postImage(),
                // ),
                Divider() //scroll view where we will show location to users
              ],
            ));
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    file = File(imageFile.path);
                  });
                }),
            SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    file = File(imageFile.path);
                  });
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage() {
    setState(() {
      uploading = true;
    });
    uploadImage(file).then((String data) {
      postToFireStore(data);
    }).then((_) {
      setState(() {
        file = null;
        uploading = false;
      });
    });
  }

  void postToFireStore(String mediaUrl) async {
    Map<String, bool> likes = Map();
    likes.putIfAbsent(user.id, () => false);
    DataBaseService().createPost(Post.fromParameters(
        Uuid().v1(), mediaUrl, user.id, likes, DateTime.now()));
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  Future<String> uploadImage(var imageFile) async {
    var id = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("post_$id.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }
}

class PostForm extends StatelessWidget {
  final imageFile;
  final bool loading;

  PostForm({this.imageFile, this.loading});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Divider(),
        Container(
          height: 360,
          width: 360,
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                alignment: FractionalOffset.topCenter,
                image: FileImage(imageFile),
              ))
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: <Widget>[
        //     Container(
        //         decoration: BoxDecoration(
        //             image: DecorationImage(
        //               fit: BoxFit.fill,
        //               alignment: FractionalOffset.topCenter,
        //               image: FileImage(imageFile),
        //             ))
        //       // height: 90.0,
        //       // width: 90.0,
        //       // child: AspectRatio(
        //       //   aspectRatio: 487 / 451,
        //       //   child: Container(
        //       //     decoration: BoxDecoration(
        //       //         image: DecorationImage(
        //       //       fit: BoxFit.fill,
        //       //       alignment: FractionalOffset.topCenter,
        //       //       image: FileImage(imageFile),
        //       //     )),
        //       //   ),
        //       // ),
        //     ),
        //   ],
        // ),
        Divider()
      ],
    );
  }
}
