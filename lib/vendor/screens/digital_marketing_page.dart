import 'package:customer/vendor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add url_launcher dependency

class DigitalMarketingPage extends StatefulWidget {
  const DigitalMarketingPage({super.key});

  @override
  State<DigitalMarketingPage> createState() => _DigitalMarketingPageState();
}

class _DigitalMarketingPageState extends State<DigitalMarketingPage> {
  final List<Map<String, dynamic>> _tiles = [
    {
      'title': 'Google Ads',
      'url': 'https://ads.google.com',
      'icon': Icons.search
    },
    {
      'title': 'Facebook Ads',
      'url': 'https://www.facebook.com/business/ads',
      'icon': Icons.facebook
    },
    {
      'title': 'Twitter Ads',
      'url': 'https://ads.twitter.com',
      'icon': Icons.one_x_mobiledata
    },
    {
      'title': 'LinkedIn Ads',
      'url': 'https://business.linkedin.com/marketing-solutions/ads',
      'icon': Icons.linked_camera
    }
  ];

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey[200], // Light background color
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Digital Marketing Console',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _tiles.map((tile) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _launchURL(tile['url']),
                      child: Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                tile['icon'] as IconData?,
                                size: 40,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tile['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
