class Post {
  String id;
  String userId;
  String mediaUrl;
  Map likes;
  DateTime timeStamp;

  Post.fromParameters(String uid, String mediaUrlLink, String userId, Map likes,
      DateTime timeStamp){
    id = uid;
    mediaUrl = mediaUrlLink;
    this.userId = userId;
    this.likes = likes;
    this.timeStamp = timeStamp;
  }

  Post.fromJson(String uid, Map<String, dynamic> values){
        this.id = uid;
        this.userId = values['userId'];
        this.mediaUrl = values['mediaUrl'];
        this.likes = values['likes'];
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "mediaUrl": mediaUrl,
      "userId": userId,
      "timeStamp": timeStamp,
      "likes":likes
    };
  }
}