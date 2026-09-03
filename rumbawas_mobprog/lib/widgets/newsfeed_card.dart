import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rumbawas_mobprog/widgets/action_button.dart';
import 'custom_font.dart';

class NewsFeedCard extends StatelessWidget {
  final String username;
  final String postContent;
  final String date;
  final int numOfLikes;
  final bool hasImage;
  final String? imageURL; // NEW: image URL for post

  const NewsFeedCard({
    super.key,
    required this.username,
    required this.postContent,
    this.numOfLikes = 0,
    this.hasImage = false,
    required this.date,
    this.imageURL, // NEW
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.sp),
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("assets/images/owl.jpg"),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFont(
                      text: username,
                      fontSize: 15.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        CustomFont(
                          text: date,
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 3.w),
                        Icon(Icons.public, color: Colors.grey, size: 15.sp),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_horiz),
              ],
            ),

            SizedBox(height: 5.h),

            CustomFont(text: postContent, fontSize: 12.sp, color: Colors.black),

            SizedBox(height: 5.h),

            // Post Image
            hasImage && imageURL != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imageURL!,
                      height: 200.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : SizedBox(height: 1.h),

            SizedBox(height: 10.h),

            Row(
              children: [
                ActionButton(
                  icon: Icons.thumb_up,
                  label: numOfLikes.toString(),
                  onTap: () {
                    print("Liked");
                  },
                ),
                ActionButton(
                  icon: Icons.comment,
                  label: "Comment",
                  onTap: () {},
                ),
                ActionButton(icon: Icons.redo, label: "Share", onTap: () {}),
              ],
            ),

            Row(
              children: [
                const CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage("assets/images/owl.jpg"),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10.w),
                    height: 25.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    alignment: Alignment.centerLeft,
                    child: CustomFont(
                      text: 'Write a comment...',
                      fontSize: 11.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            CustomFont(
              text: 'View comments',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
