class Post {
  final int id;
  final int postId;
  final int userId;
  final String title;
  final String body;
  final int likes;
  final int dislikes;
  final String createdAt;
  final String updatedAt;

  Post({
    required this.id,
    required this.postId,
    required this.userId,
    required this.title,
    required this.body,
    required this.likes,
    required this.dislikes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final reactions =
        json['reactions'] as Map<String, dynamic>?;

    return Post(
      id: (json['id'] as num?)?.toInt() ?? 0,
      postId:
          (json['postId'] as num?)?.toInt() ??
          (json['post_id'] as num?)?.toInt() ??
          0,
      userId:
          (json['userId'] as num?)?.toInt() ??
          (json['user_id'] as num?)?.toInt() ??
          0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      likes:
          (reactions?['likes'] as num?)?.toInt() ??
          (json['likes'] as num?)?.toInt() ??
          0,
      dislikes:
          (reactions?['dislikes'] as num?)?.toInt() ??
          (json['dislikes'] as num?)?.toInt() ??
          0,
      createdAt:
          json['createdAt']?.toString() ??
          json['created_at']?.toString() ??
          '',
      updatedAt:
          json['updatedAt']?.toString() ??
          json['updated_at']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'title': title,
      'body': body,
      'reactions': {
        'likes': likes,
        'dislikes': dislikes,
      },
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}