import 'package:customer/vendor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({super.key});

  @override
  State<VendorProfilePage> createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  final String userId =
      "65EQdX4i4lzaxJwhMgh1"; // Replace this with the actual user ID

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String name = userData['user_name'] ?? '';
            String email = userData['user_email'] ?? '';
            String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "";
            String phone = userData['user_ph'].toString();
            String businessName = userData['b_name'] ?? 'N/A';
            String businessAddress = userData['b_adress'] ?? 'N/A';
            String businessTxId = userData['b_txid'] ?? 'N/A';
            String businessType = userData['b_type'] ?? 'N/A';
            String qrImageUrl =
                userData['qr_image'] ?? ''; // URL for the QR code image

            return SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: Profile details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: primaryColor,
                          child: Text(
                            firstLetter,
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white, // Change to white
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Change to white
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Divider(
                            color: Colors.white), // Change Divider color
                        const SizedBox(height: 10),
                        _buildProfileDetail('Phone', phone),
                        _buildProfileDetail('Business Name', businessName),
                        _buildProfileDetail(
                            'Business Address', businessAddress),
                        _buildProfileDetail('Transaction ID', businessTxId),
                        _buildProfileDetail('Business Type', businessType),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .blue, // Customize button color if needed
                            ),
                            child: const Text("Edit Profile",
                                style: TextStyle(
                                    color: Colors.white)), // Text color white
                            onPressed: () {
                              // Implement the edit profile functionality here
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right side: QR code image
                  Column(
                    children: [
                      if (qrImageUrl.isNotEmpty)
                        Image.network(
                          qrImageUrl,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      const SizedBox(height: 10),
                      const Text(
                        'Scan this QR code for details',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style:
                      const TextStyle(color: Colors.white)), // Error text white
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Change to white
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // Change to white
              ),
            ),
          ),
        ],
      ),
    );
  }
}
