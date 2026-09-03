import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import '../screens/newsfeed_screen.dart';
import '../screens/notification_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/custom_font.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  String getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return "BrainHub";
      case 1:
        return "Notifications";
      case 2:
        return "Kaye Rumbawa";
      default:
        return "BrainHub";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FB_PRIMARY,
        elevation: 1,
        title: CustomFont(
          text: getAppBarTitle(),
          fontSize: 23.sp,
          color: Colors.white,
          fontFamily: 'Klavika',
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() => _selectedIndex = page);
        },
        children: const [
          NewsFeedScreen(),
          NotificationScreen(),
          ProfileScreen(), // ✅ UPDATED
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: FB_PRIMARY,
        unselectedItemColor: Colors.grey,
        onTap: _onTappedBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  void _onTappedBar(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }
}
