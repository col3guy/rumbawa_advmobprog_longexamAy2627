import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/comment.dart';

class CommentService {
  Future<List<Comment>> getComments(int postId) async {
    final uri = Uri.parse(
      '$API_URL/comments/post/$postId',
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body);

      final List commentsJson =
          data['comments'] ?? [];

      return commentsJson
          .map(
            (comment) => Comment.fromJson(comment),
          )
          .toList();
    }

    throw Exception(
      'Failed to load comments: ${response.statusCode}',
    );
  }

  Future<Comment> addComment({
    required int postId,
    required int userId,
    required String body,
  }) async {
    final uri = Uri.parse(
      '$API_URL/comments/add',
    );

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'body': body,
        'postId': postId,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      final Map<String, dynamic> data =
          jsonDecode(response.body);

      return Comment.fromJson(data);
    }

    throw Exception(
      'Failed to add comment: ${response.statusCode}',
    );
  }
}