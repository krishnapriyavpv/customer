import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/constants.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('inventory_list').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final List<PieChartSectionData> sections = [];

          for (var doc in snapshot.data!.docs) {
            final quantity = doc['quantity'] as int;

            sections.add(PieChartSectionData(
              color: getColorBasedOnQuantity(quantity),
              value: quantity.toDouble(),
              // title: '$prodName\n${getStatus(quantity)}',
              radius: 30,
              titleStyle: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ));
          }

          return SizedBox(
            height: 290,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    sections: sections,
                  ),
                ),
                const Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: defaultPadding),
                      Text(
                        "Inventory Status",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No inventory data found.'));
        }
      },
    );
  }

  // Function to categorize the quantity
  String getStatus(int quantity) {
    if (quantity >= 50) {
      return "Sufficient";
    } else if (quantity >= 10) {
      return "Medium";
    } else {
      return "Critical";
    }
  }

  // Function to determine the color based on quantity
  Color getColorBasedOnQuantity(int quantity) {
    if (quantity >= 50) {
      return Colors.green;
    } else if (quantity >= 10) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
