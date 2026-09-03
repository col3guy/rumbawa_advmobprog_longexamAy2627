import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rumbawas_mobprog/constants.dart';

class DetailScreen extends StatefulWidget {
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final String imageUrl;
  final String profileImageUrl;

  const DetailScreen({
    super.key,
    required this.userName,
    required this.postContent,
    required this.date,
    this.numOfLikes = 0,
    this.imageUrl = '',
    this.profileImageUrl = '',
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int likes;

  @override
  void initState() {
    super.initState();
    likes = widget.numOfLikes;
  }

  void _incrementLike() {
    setState(() {
      likes++;
    });
  }

  // ✅ supports BOTH assets and network urls
  ImageProvider? _imageProvider(String pathOrUrl) {
    final p = pathOrUrl.trim();
    if (p.isEmpty) return null;

    if (p.startsWith('http://') || p.startsWith('https://')) {
      return NetworkImage(p);
    }
    return AssetImage(p);
  }

  @override
  Widget build(BuildContext context) {
    final avatarImage = _imageProvider(widget.profileImageUrl);

    return WillPopScope(
      // ✅ when user presses back, send likes back
      onWillPop: () async {
        Navigator.pop(context, likes);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // ✅ when pressing back button in appbar, send likes back too
              Navigator.pop(context, likes);
            },
          ),
          title: Text(
            widget.userName,
            style: TextStyle(fontSize: 20.sp, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.imageUrl.trim().isNotEmpty)
                (widget.imageUrl.startsWith('http://') ||
                        widget.imageUrl.startsWith('https://'))
                    ? Image.network(widget.imageUrl)
                    : Image.asset(widget.imageUrl),

              SizedBox(height: 20.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: avatarImage,
                      child: avatarImage == null
                          ? const Icon(Icons.person,
                              size: 40, color: Colors.white)
                          : null,
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.date,
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (widget.postContent.trim().isNotEmpty) ...[
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    widget.postContent,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ],

              SizedBox(height: 30.h),
              const Divider(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _incrementLike,
                      icon:
                          const Icon(Icons.thumb_up, color: FB_DARK_PRIMARY),
                      label: Text(
                        likes == 0 ? 'Like' : likes.toString(),
                        style: TextStyle(
                            fontSize: 12.sp, color: FB_DARK_PRIMARY),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon:
                          const Icon(Icons.comment, color: FB_DARK_PRIMARY),
                      label:
                          Text('Comment', style: TextStyle(fontSize: 12.sp)),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.redo, color: FB_DARK_PRIMARY),
                      label:
                          Text('Share', style: TextStyle(fontSize: 12.sp)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
