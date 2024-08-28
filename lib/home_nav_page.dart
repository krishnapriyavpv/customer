import 'package:customer/cart_page.dart';
import 'package:customer/home_page.dart';
import 'package:customer/profile_page.dart';
import 'package:flutter/material.dart';

class HomeNavPage extends StatefulWidget {
  const HomeNavPage({super.key});

  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: SideNavBar(),
      appBar: AppBar(
        title: const Text(
          "Juice Point",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        // backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PageView(
        controller: _pageController,
        children: const <Widget>[
          HomePage(),
          // MenuPage(),
          CartPage(),
          ProfilePage(),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Colors.blue, // Replace with your desired background color
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _currentPage,
        onTap: (int index) {
          setState(() {
            _currentPage = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_rounded),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
