import 'package:customer/vendor/screens/auth/cust_sign.dart';
import 'package:customer/vendor/screens/auth/vendor_sign.dart';
import 'package:flutter/material.dart';

class SignUpChoosePage extends StatefulWidget {
  const SignUpChoosePage({super.key});

  @override
  State<SignUpChoosePage> createState() => _SignUpChoosePageState();
}

class _SignUpChoosePageState extends State<SignUpChoosePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sign up as Customer Button
            ElevatedButton(
              onPressed: () {
                // Navigate to Sign Up as Customer Page

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomerSignUpPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 120),
                backgroundColor: Colors.blue, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 40, color: Colors.white),
                  SizedBox(width: 20),
                  Text(
                    'Sign Up as Customer',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Sign up as Vendor Button
            ElevatedButton(
              onPressed: () {
                // Navigate to Sign Up as Vendor Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const VendorSignUpPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 120),
                backgroundColor: Colors.green, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store, size: 40, color: Colors.white),
                  SizedBox(width: 20),
                  Text(
                    'Sign Up as Vendor',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
