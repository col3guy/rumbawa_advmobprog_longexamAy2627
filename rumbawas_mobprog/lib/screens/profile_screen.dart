import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/post.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import '../widgets/post_card.dart';
import 'newsfeed_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final PostService _postService = PostService();

  List<Post> posts = [];

  bool loading = true;
  bool following = false;

  int selectedTab = 0;

  String displayName = '';
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final userId = await _authService.getUserId();
      final savedName = await _authService.getFullName();
      final savedUsername = await _authService.getUsername();

      if (!mounted) return;

      setState(() {
        displayName =
            (savedName == null || savedName.trim().isEmpty)
                ? 'User'
                : savedName;

        username = savedUsername ?? '';

        loading = false;
      });

      if (userId == null) {
        return;
      }

      try {
        final userPosts =
            await _postService.getPostsByUser(userId);

        if (!mounted) return;

        setState(() {
          posts = userPosts;
        });
      } catch (_) {
        if (!mounted) return;

        setState(() {
          posts = [];
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      _showMessage('Failed to load profile.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _onBottomNavigationTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const NewsFeedScreen(),
        ),
      );
    } else if (index == 1) {
      _showMessage('No new notifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : Colors.white;

    final secondaryBackground = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF5F5F5);

    final textColor =
        isDark ? Colors.white : Colors.black;

    final secondaryTextColor =
        isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: Text(
          displayName.isEmpty
              ? 'Profile'
              : displayName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor:
            isDark ? FB_DARK_PRIMARY : FB_PRIMARY,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: FB_PRIMARY,
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadProfile,
              child: ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  // COVER + PROFILE
                  SizedBox(
                    height: 245,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // COVER PHOTO
                        GestureDetector(
                          onTap: () {
                            _showMessage(
                              'Cover photo selected',
                            );
                          },
                          child: SizedBox(
                            height: 195,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/Japan.webp',
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (
                                    context,
                                    error,
                                    stackTrace,
                                  ) {
                                    return Container(
                                      color: FB_PRIMARY,
                                      child:
                                          const Center(
                                        child: Icon(
                                          Icons.image,
                                          color:
                                              Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                    );
                                  },
                            ),
                          ),
                        ),

                        // GENERIC PROFILE ICON
                        Positioned(
                          left: 16,
                          top: 145,
                          child: Container(
                            padding:
                                const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child:
                                const CircleAvatar(
                              radius: 43,
                              backgroundColor:
                                  Colors.grey,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // CAMERA BUTTON
                        Positioned(
                          left: 88,
                          top: 190,
                          child: GestureDetector(
                            onTap: () {
                              _showMessage(
                                'Change profile photo',
                              );
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration:
                                  BoxDecoration(
                                color:
                                    secondaryBackground,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      backgroundColor,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 17,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // DISPLAY NAME
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 3),

                  // USERNAME
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      username.isEmpty
                          ? '@username'
                          : '@$username',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // FOLLOWERS
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '3M',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'followers',
                          style: TextStyle(
                            color:
                                secondaryTextColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '5',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'following',
                          style: TextStyle(
                            color:
                                secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // FOLLOW + MESSAGE
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                following =
                                    !following;
                              });

                              _showMessage(
                                following
                                    ? 'Following $displayName'
                                    : 'Unfollowed $displayName',
                              );
                            },
                            style: ElevatedButton
                                .styleFrom(
                              backgroundColor:
                                  following
                                      ? FB_PRIMARY
                                      : secondaryBackground,
                              foregroundColor:
                                  following
                                      ? Colors.white
                                      : textColor,
                              elevation: 0,
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              following
                                  ? 'Following'
                                  : 'Follow',
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _showMessage(
                                'Opening messages...',
                              );
                            },
                            style: OutlinedButton
                                .styleFrom(
                              foregroundColor:
                                  textColor,
                              side: BorderSide(
                                color: isDark
                                    ? Colors.grey[700]!
                                    : Colors.grey[400]!,
                              ),
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                vertical: 12,
                              ),
                            ),
                            child:
                                const Text('Message'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // TABS
                  Divider(
                    height: 1,
                    color: isDark
                        ? Colors.grey[800]
                        : Colors.grey[300],
                  ),

                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        _buildTab(
                          'Posts',
                          0,
                          textColor,
                          secondaryTextColor,
                        ),
                        _buildTab(
                          'About',
                          1,
                          textColor,
                          secondaryTextColor,
                        ),
                        _buildTab(
                          'Photos',
                          2,
                          textColor,
                          secondaryTextColor,
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    color: isDark
                        ? Colors.grey[800]
                        : Colors.grey[300],
                  ),

                  if (selectedTab == 0)
                    _buildPostsTab(textColor)
                  else if (selectedTab == 1)
                    _buildAboutTab(
                      textColor,
                      secondaryTextColor,
                    )
                  else
                    _buildPhotosTab(
                      textColor,
                      secondaryTextColor,
                    ),
                ],
              ),
            ),

      // BOTTOM NAVIGATION
      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: FB_PRIMARY,
        unselectedItemColor:
            isDark ? Colors.grey[500] : Colors.grey,
        backgroundColor: isDark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        type:
            BottomNavigationBarType.fixed,
        onTap: _onBottomNavigationTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab(Color textColor) {
    if (posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            'No posts found.',
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: posts.map((post) {
          return PostCard(post: post);
        }).toList(),
      ),
    );
  }

  Widget _buildAboutTab(
    Color textColor,
    Color? secondaryTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'About $displayName',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 16),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.person,
              color: textColor,
            ),
            title: Text(
              displayName,
              style: TextStyle(
                color: textColor,
              ),
            ),
            subtitle: Text(
              username.isEmpty
                  ? 'Username: @username'
                  : 'Username: @$username',
              style: TextStyle(
                color: secondaryTextColor,
              ),
            ),
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.people,
              color: textColor,
            ),
            title: Text(
              '3M followers',
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.favorite,
              color: textColor,
            ),
            title: Text(
              '5 following',
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosTab(
    Color textColor,
    Color? secondaryTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.photo_library,
              size: 60,
              color: secondaryTextColor,
            ),

            const SizedBox(height: 12),

            Text(
              'Photos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'No photos available.',
              style: TextStyle(
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    String title,
    int index,
    Color textColor,
    Color? secondaryTextColor,
  ) {
    final isSelected =
        selectedTab == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isSelected
                    ? FB_PRIMARY
                    : secondaryTextColor,
              ),
            ),

            const SizedBox(height: 7),

            if (isSelected)
              Container(
                height: 3,
                width: 55,
                color: FB_PRIMARY,
              ),
          ],
        ),
      ),
    );
  }
}