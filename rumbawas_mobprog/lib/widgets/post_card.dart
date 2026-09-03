import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../services/auth_service.dart';
import '../services/comment_service.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final CommentService _commentService = CommentService();
  final AuthService _authService = AuthService();

  final TextEditingController _commentController =
      TextEditingController();

  bool liked = false;
  bool loadingComments = false;
  bool sendingComment = false;

  List<Comment> comments = [];

  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    likeCount = widget.post.likes;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // ==========================
  // LIKE / UNLIKE
  // ==========================

  void _likePost() {
    setState(() {
      if (liked) {
        // UNLIKE
        liked = false;

        if (likeCount > 0) {
          likeCount--;
        }
      } else {
        // LIKE
        liked = true;
        likeCount++;
      }
    });
  }

  // ==========================
  // LOAD COMMENTS
  // ==========================

  Future<void> _loadComments() async {
    setState(() {
      loadingComments = true;
    });

    try {
      final result = await _commentService.getComments(
        widget.post.id,
      );

      if (!mounted) return;

      setState(() {
        for (final newComment in result) {
          final exists = comments.any(
            (existingComment) =>
                existingComment.id == newComment.id &&
                newComment.id != 0,
          );

          if (!exists) {
            comments.add(newComment);
          }
        }

        loadingComments = false;
      });

      _showComments();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingComments = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to load comments: $e',
          ),
        ),
      );
    }
  }

  // ==========================
  // ADD COMMENT
  // ==========================

  Future<void> _addComment(
    StateSetter setModalState,
  ) async {
    final text = _commentController.text.trim();

    if (text.isEmpty) {
      return;
    }

    final userId = await _authService.getUserId();

    if (userId == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please login again before commenting.',
          ),
        ),
      );

      return;
    }

    setModalState(() {
      sendingComment = true;
    });

    try {
      final newComment =
          await _commentService.addComment(
        postId: widget.post.id,
        userId: userId,
        body: text,
      );

      if (!mounted) return;

      setState(() {
        final exists = comments.any(
          (comment) =>
              comment.id == newComment.id &&
              newComment.id != 0,
        );

        if (!exists) {
          comments.add(newComment);
        }
      });

      setModalState(() {
        sendingComment = false;
      });

      _commentController.clear();
    } catch (e) {
      if (!mounted) return;

      setModalState(() {
        sendingComment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to add comment: $e',
          ),
        ),
      );
    }
  }

  // ==========================
  // SHOW COMMENTS
  // ==========================

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (
            context,
            setModalState,
          ) {
            return SafeArea(
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height *
                        0.75,
                child: Column(
                  children: [
                    // ==========================
                    // HEADER
                    // ==========================

                    Padding(
                      padding:
                          const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Comments (${comments.length})',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1),

                    // ==========================
                    // COMMENT LIST
                    // ==========================

                    Expanded(
                      child: comments.isEmpty
                          ? const Center(
                              child: Text(
                                'No comments yet.',
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.all(
                                8,
                              ),
                              itemCount:
                                  comments.length,
                              itemBuilder: (
                                context,
                                index,
                              ) {
                                final comment =
                                    comments[index];

                                String displayName =
                                    'User';

                                if (comment.fullName
                                    .trim()
                                    .isNotEmpty) {
                                  displayName =
                                      comment.fullName;
                                } else if (comment
                                    .username
                                    .trim()
                                    .isNotEmpty) {
                                  displayName =
                                      comment.username;
                                }

                                return Container(
                                  margin:
                                      const EdgeInsets
                                          .only(
                                    bottom: 10,
                                  ),
                                  padding:
                                      const EdgeInsets
                                          .all(12),
                                  decoration:
                                      BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    )
                                        .colorScheme
                                        .surface,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      12,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      const CircleAvatar(
                                        radius: 20,
                                        child: Icon(
                                          Icons.person,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              displayName,
                                              style:
                                                  const TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              comment.body,
                                              style:
                                                  const TextStyle(
                                                fontSize:
                                                    15,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${comment.likes} ❤️',
                                                  style:
                                                      TextStyle(
                                                    fontSize:
                                                        12,
                                                    color: Theme
                                                            .of(
                                                          context,
                                                        )
                                                        .textTheme
                                                        .bodySmall
                                                        ?.color,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    // ==========================
                    // COMMENT INPUT
                    // ==========================

                    Container(
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 8,
                        bottom:
                            MediaQuery.of(context)
                                    .viewInsets
                                    .bottom +
                                8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor,
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context)
                                .dividerColor,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextField(
                              controller:
                                  _commentController,
                              minLines: 1,
                              maxLines: 4,
                              textCapitalization:
                                  TextCapitalization
                                      .sentences,
                              decoration:
                                  InputDecoration(
                                hintText:
                                    'Write a comment...',
                                filled: true,
                                fillColor:
                                    Theme.of(context)
                                        .colorScheme
                                        .surface,
                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    25,
                                  ),
                                  borderSide:
                                      BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          sendingComment
                              ? const SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(12),
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    _addComment(
                                      setModalState,
                                    );
                                  },
                                  style:
                                      IconButton.styleFrom(
                                    backgroundColor:
                                        FB_PRIMARY,
                                    foregroundColor:
                                        Colors.white,
                                    fixedSize:
                                        const Size(
                                      45,
                                      45,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.send,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================
  // POST CARD
  // ==========================

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // POST BODY
            Text(
              widget.post.body,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            // ACTION BUTTONS
            Row(
              children: [
                // LIKE
                IconButton(
                  onPressed: _likePost,
                  icon: Icon(
                    liked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: liked
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),

                // LIKE COUNT
                Text(
                  '$likeCount',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(width: 12),

                // COMMENTS
                TextButton.icon(
                  onPressed: loadingComments
                      ? null
                      : _loadComments,
                  icon: const Icon(
                    Icons.comment,
                  ),
                  label: Text(
                    comments.isEmpty
                        ? 'Comments'
                        : '${comments.length} Comments',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}