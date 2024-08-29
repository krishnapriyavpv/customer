import 'package:customer/profile_page.dart';
import 'package:customer/vendor/controllers/menu_app_controller.dart';
import 'package:customer/vendor/screens/dashboard/dashboard_screen.dart';
import 'package:customer/vendor/screens/digital_marketing_page.dart';
import 'package:customer/vendor/screens/inventory_list_page.dart';
import 'package:customer/vendor/screens/notification_page.dart';
import 'package:customer/vendor/screens/orders_page.dart';
import 'package:customer/vendor/screens/profile_page.dart';
import 'package:customer/vendor/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(
        onItemSelected: _onDrawerItemTapped,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(
                  onItemSelected: _onDrawerItemTapped,
                ), // Fixed side menu for desktop
              ),
            Expanded(
              flex: 5,
              child: IndexedStack(
                index: _selectedIndex,
                children: const [
                  DashboardScreen(),
                  OrdersPage(),
                  // Add other pages here
                  InventoryPage(),
                  DashboardScreen(),
                  DashboardScreen(),
                  DigitalMarketingPage(),
                  SendNotificationPage(),
                  VendorProfilePage(),
                  DashboardScreen()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
