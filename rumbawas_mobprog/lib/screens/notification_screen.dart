import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, Object?>> notifications = [
    {
      "name": "Kaye Rumbawa",
      "postContent": "your photo",
      "description": "reacted ❤️ to your post",
      "date": "2h ago",
      "image": "assets/images/owl.jpg",
      "likes": 0,
      "profileImageUrl": "assets/images/profile.jpg",
    },
    {
      "name": "Miguel Santos",
      "postContent": "Nice one!",
      "description": "commented on your post",
      "date": "3h ago",
      "image": null,
      "likes": 0,
      "profileImageUrl": "assets/images/finn.jpg",
    },
    {
      "name": "Aira Mendoza",
      "postContent": "shared your post",
      "description": "shared your post",
      "date": "5h ago",
      "image": null,
      "likes": 0,
      "profileImageUrl": "assets/images/sadie.webp",
    },
    {
      "name": "Patrick Cruz",
      "postContent": "your story",
      "description": "reacted 👍 to your story",
      "date": "1h ago",
      "image": "assets/images/owl.jpg",
      "likes": 0,
      "profileImageUrl": "assets/images/noah.webp",
    },
    {
      "name": "Andrea Dela Cruz",
      "postContent": "mentioned you in a comment",
      "description": "mentioned you in a comment",
      "date": "4h ago",
      "image": null,
      "likes": 0,
      "profileImageUrl": "assets/images/millie.avif",
    },
    {
      "name": "Lebleb Macalintal",
      "postContent": "mentioned you in a comment",
      "description": "mentioned you in a comment",
      "date": "4h ago",
      "image": null,
      "likes": 0,
      "profileImageUrl": "assets/images/lebleb.webp",
    },
    {
      "name": "Gado Mataraso",
      "postContent": "mentioned you in a comment",
      "description": "mentioned you in a comment",
      "date": "4h ago",
      "image": null,
      "likes": 0,
      "profileImageUrl": "assets/images/gado.webp",
    },
    {
      "name": "Rebecca Sison",
      "postContent": "mentioned you in a comment",
      "description": "mentioned you in a comment",
      "date": "4h ago",
      "image": null,
      "likes": 0,
      "profileImageUrl": "assets/images/jisoo.webp",
    },
    {
      "name": "Tobias",
      "postContent": "your story",
      "description": "reacted ❤︎ to your story",
      "date": "1h ago",
      "image": "assets/images/owl.jpg",
      "likes": 0,
      "profileImageUrl": "assets/images/tobi.jpg",
    },
    {
      "name": "Cloudy",
      "postContent": "your story",
      "description": "reacted 👍 to your story",
      "date": "1h ago",
      "image": "assets/images/owl.jpg",
      "likes": 0,
      "profileImageUrl": "assets/images/cloud.avif",
    },
  ];

  String _detailPostText({
    required String postContent,
    required String description,
    required bool hasImage,
  }) {
    if (hasImage) return description;
    final t = postContent.trim();
    return t.isNotEmpty ? t : description;
  }

  ImageProvider _imageProvider(String pathOrUrl) {
    final p = pathOrUrl.trim();
    if (p.startsWith('http://') || p.startsWith('https://')) {
      return NetworkImage(p);
    }
    return AssetImage(p);
  }

  void _likeNotification(int index) {
    setState(() {
      final current = (notifications[index]["likes"] as int?) ?? 0;
      notifications[index]["likes"] = current + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notif = notifications[index];

          final String name = (notif["name"] as String?) ?? "";
          final String postContent = (notif["postContent"] as String?) ?? "";
          final String description = (notif["description"] as String?) ?? "";
          final String date = (notif["date"] as String?) ?? "";
          final String imagePath = (notif["image"] as String?) ?? "";
          final int likes = (notif["likes"] as int?) ?? 0;

          final String profileImageUrl =
              (notif["profileImageUrl"] as String?) ??
              "assets/images/default_profile.jpg";

          final bool hasImage = imagePath.trim().isNotEmpty;

          final String detailText = _detailPostText(
            postContent: postContent,
            description: description,
            hasImage: hasImage,
          );

          return InkWell(
            onTap: () async {
              // ✅ OPEN DETAIL + RECEIVE UPDATED LIKES WHEN BACK
              final updatedLikes = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(
                    userName: name,
                    postContent: detailText,
                    date: date,
                    numOfLikes: likes,
                    imageUrl: imagePath,
                    profileImageUrl: profileImageUrl,
                  ),
                ),
              );

              // ✅ update the likes in this notification after returning
              if (updatedLikes != null) {
                setState(() {
                  notifications[index]["likes"] = updatedLikes;
                });
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundImage: _imageProvider(profileImageUrl),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              height: 1.25,
                            ),
                            children: [
                              TextSpan(
                                text: "$name ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: description),
                            ],
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 10.w),

                            // ✅ LIKE BUTTON ON NOTIFICATION (no need to open post)
                            InkWell(
                              onTap: () => _likeNotification(index),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    size: 16.sp,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    likes.toString(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  if (hasImage) ...[
                    SizedBox(width: 12.w),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.asset(
                        imagePath,
                        width: 54.w,
                        height: 54.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
