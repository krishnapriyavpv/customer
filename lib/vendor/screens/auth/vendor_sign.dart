// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/vendor/utils/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:customer/vendor/utils/responsive.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class VendorSignUpPage extends StatefulWidget {
  const VendorSignUpPage({super.key});

  @override
  State<VendorSignUpPage> createState() => _VendorSignUpPageState();
}

class _VendorSignUpPageState extends State<VendorSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _unserNameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 90,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Responsive.isMobile(context) ? double.infinity : 400,
                    child: TextFormField(
                      controller: _unserNameController,
                      decoration: InputDecoration(
                        labelText: "User Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter user name";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: Responsive.isMobile(context) ? double.infinity : 400,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "User Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: primaryColor, // Set the border color
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            width: 2.5, // Set the border thickness
                            color: primaryColor, // Set the border color
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter email id";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: Responsive.isMobile(context) ? double.infinity : 400,
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter valid password";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width:
                          Responsive.isMobile(context) ? double.infinity : 400,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          }
                          if (value != _passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorSignUpPage2(
                              userEmail: _emailController.text,
                              userName: '',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please fill in all fields correctly'),
                          ),
                        );
                      }
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VendorSignUpPage2 extends StatefulWidget {
  final String userEmail;
  final String userName;

  const VendorSignUpPage2({
    super.key,
    required this.userEmail,
    required this.userName,
  });

  @override
  State<VendorSignUpPage2> createState() => _VendorSignUpPage2State();
}

class _VendorSignUpPage2State extends State<VendorSignUpPage2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _businessAddressController =
      TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();
  String data = '';
  final GlobalKey _qrkey = GlobalKey();
  bool _isUploading = false;
  String? _imageUrl;

  @override
  void dispose() {
    _storeNameController.dispose();
    _businessTypeController.dispose();
    _businessAddressController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }

  Future<void> _saveVendorDetails(String qrImageUrl) async {
    if (_formKey.currentState!.validate()) {
      // Data to save
      Map<String, dynamic> vendorData = {
        'b_address': _businessAddressController.text,
        'b_name': _storeNameController.text,
        'b_txid': _taxIdController.text,
        'b_type': _businessTypeController.text,
        'type': 'vendor',
        'user_email': widget.userEmail, // Accessing userEmail
        'user_name': widget.userName, // Accessing userName
        'qr_image': qrImageUrl, // Storing QR image URL
      };

      // Save to Firestore
      await FirebaseFirestore.instance.collection('user').add(vendorData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vendor details saved successfully')),
      );

      // Navigate to the next screen or perform other actions
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly')),
      );
    }
  }

  Future<void> _captureAndUploadPng() async {
    setState(() {
      _isUploading = true;
    });
    try {
      RenderRepaintBoundary boundary =
          _qrkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);

      // Drawing White Background because QR Code is Black
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the image as a temporary file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/qr_code.png');
      await file.writeAsBytes(pngBytes);

      // Upload the file to Firebase Storage
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('qr_codes/$timestamp.png');
      UploadTask uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        _imageUrl = await storageReference.getDownloadURL();
        setState(() {
          _isUploading = false;
        });

        if (_imageUrl != null) {
          // Save vendor details with the QR code URL
          _saveVendorDetails(_imageUrl!);
          const snackBar = SnackBar(
              content: Text('QR code uploaded and vendor details saved'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      const snackBar = SnackBar(content: Text('Something went wrong!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _showQrPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Your QR Code',
            style: TextStyle(color: Colors.black),
          ),
          content: SizedBox(
            width: 250.0,
            height: 250.0,
            child: RepaintBoundary(
              key: _qrkey,
              child: QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 250.0,
                gapless: true,
                errorStateBuilder: (ctx, err) {
                  return const Center(
                    child: Text(
                      'Something went wrong!',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            ElevatedButton(
              onPressed: _isUploading
                  ? null
                  : () async {
                      await _captureAndUploadPng();
                      Navigator.of(context).pop(); // Close the QR popup

                      // Pop all pages and navigate to the login page
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', // Replace with the route name for your login page
                          (Route<dynamic> route) => false);
                    },
              child: const Text('Export'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 90,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Responsive.isMobile(context) ? double.infinity : 400,
                    child: TextFormField(
                      controller: _storeNameController,
                      decoration: InputDecoration(
                        labelText: "Store Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Store name";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width:
                          Responsive.isMobile(context) ? double.infinity : 400,
                      child: TextFormField(
                        controller: _businessTypeController,
                        decoration: InputDecoration(
                          labelText: "Business Type",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Business type";
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 20),
                  SizedBox(
                      width:
                          Responsive.isMobile(context) ? double.infinity : 400,
                      child: TextFormField(
                        controller: _businessAddressController,
                        decoration: InputDecoration(
                          labelText: "Business Address",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.5),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Business address";
                          }
                          return null;
                        },
                      )),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: Responsive.isMobile(context) ? double.infinity : 400,
                    child: TextFormField(
                      controller: _taxIdController,
                      decoration: InputDecoration(
                        labelText: "Tax ID",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Tax ID";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          data =
                              "https://storefront-db898.web.app/${_storeNameController.text}"; // Update the data with the store name
                        });
                        if (data.isNotEmpty) {
                          _showQrPopup();
                          _saveVendorDetails;
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please fill in all fields correctly'),
                          ),
                        );
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
