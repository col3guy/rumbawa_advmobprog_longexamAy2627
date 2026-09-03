// lib/services/post_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/post.dart';

class PostService {
  Future<List<Post>> getPosts({
    int limit = 30,
    int skip = 0,
  }) async {
    final uri = Uri.parse(
      '$API_URL/posts?limit=$limit&skip=$skip',
    );

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load posts: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    final List postsJson = data['posts'] ?? [];

    return postsJson
        .map(
          (post) => Post.fromJson(
            Map<String, dynamic>.from(post),
          ),
        )
        .toList();
  }

  Future<List<Post>> getPostsByUser(int userId) async {
    final uri = Uri.parse(
      '$API_URL/users/$userId/posts',
    );

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load user posts: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    final List postsJson = data['posts'] ?? [];

    return postsJson
        .map(
          (post) => Post.fromJson(
            Map<String, dynamic>.from(post),
          ),
        )
        .toList();
  }
}