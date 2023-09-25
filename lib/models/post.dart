// This Model will be used for Posts and its details

class PostModel {
  final int postId;
  final int userId;
  final String content;
  final bool hadMedia;
  final int interactionsCount;
  final int commentsCount;
  final Model model;
  final List<Media> media;

  const PostModel({
    required this.postId,
    required this.userId,
    required this.content,
    required this.hadMedia,
    required this.interactionsCount,
    required this.commentsCount,
    required this.model,
    required this.media,
  });

  factory PostModel.fromJson(dynamic json) {
    return PostModel(
      postId: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      content: json['content'] ?? '',
      hadMedia: json['has_media'] ?? '',
      interactionsCount: json['interactions_count'] ?? '',
      commentsCount: json['comments_count'] ?? '',
      model: Model.fromJson(json['model']),
      media:
          List<Media>.from(json['media'].map((media) => Media.fromJson(media))),
    );
  }

  static List<PostModel> postFromSnapshot(List postSnapshot) {
    return postSnapshot.map((json) {
      return PostModel.fromJson(json);
    }).toList();
  }
}

class Model {
  dynamic id;
  dynamic userId;
  String name;

  List<Media> media;

  Model({
    required this.id,
    required this.userId,
    required this.name,
    required this.media,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      media:
          List<Media>.from(json['media'].map((media) => Media.fromJson(media))),
    );
  }
}

class Media {
  int id;
  String srcUrl;
  String mediaType;

  Media({
    required this.id,
    required this.srcUrl,
    required this.mediaType,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      srcUrl: json['src_url'],
      mediaType: json['media_type'],
    );
  }
}
