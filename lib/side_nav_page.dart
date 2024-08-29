import 'package:customer/vendor/controllers/menu_app_controller.dart';
import 'package:customer/vendor/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideNavPage extends StatefulWidget {
  const SideNavPage({super.key});

  @override
  State<SideNavPage> createState() => _SideNavPageState();
}

class _SideNavPageState extends State<SideNavPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(child: Text("StoreFront")),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("Login Portal"),
            tileColor: Colors.blue[100],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (context) => MenuAppController(),
                      ),
                    ],
                    child: const MainScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
