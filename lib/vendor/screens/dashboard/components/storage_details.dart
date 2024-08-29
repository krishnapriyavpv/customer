import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quantity Analysis",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          StorageInfoCard(
            icon: Icons.warning,
            color: Colors.red,
            title: "Critical Stocks",
            amountOfFiles: "5 Products",
          ),
          StorageInfoCard(
            icon: Icons.archive,
            color: Colors.amber,
            title: "Sufficient Stocks",
            amountOfFiles: "9 Products",
          ),
          StorageInfoCard(
            icon: Icons.check_circle,
            color: Colors.green,
            title: "Surplus Stocks",
            amountOfFiles: "20 Products",
          ),
        ],
      ),
    );
  }
}
