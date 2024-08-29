import 'package:customer/vendor/screens/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
    required this.onItemSelected,
  });

  final void Function(int) onItemSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () => onItemSelected(0),
          ),
          DrawerListTile(
            title: "Orders",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () => onItemSelected(1),
          ),
          DrawerListTile(
            title: "Inventory List",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () => onItemSelected(2),
          ),
          DrawerListTile(
            title: "Report",
            svgSrc: "assets/icons/menu_task.svg",
            press: () => onItemSelected(3),
          ),
          DrawerListTile(
            title: "Track Quantity",
            svgSrc: "assets/icons/menu_store.svg",
            press: () => onItemSelected(4),
          ),
          DrawerListTile(
            title: "Social Media",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () => onItemSelected(5),
          ),
          DrawerListTile(
            title: "Send Notifications Media",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () => onItemSelected(6),
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () => onItemSelected(7),
          ),
          DrawerListTile(
            title: "Log Out",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LogInPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
