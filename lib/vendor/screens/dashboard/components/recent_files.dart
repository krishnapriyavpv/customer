import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../utils/constants.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('order_history')
          .orderBy('order_date', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent Orders",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal, // Add horizontal scrolling
                    child: SizedBox(
                      width: 810, // Adjust the width to avoid overflow
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(primaryColor),
                        columns: const [
                          DataColumn(
                            label: Flexible(
                              // Use Flexible to handle overflow
                              child: Text(
                                'Order ID',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Flexible(
                              child: Text(
                                'Amount',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Flexible(
                              child: Text(
                                'Status',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Flexible(
                              child: Text(
                                'Order Date',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Flexible(
                              child: Text(
                                'Delivery Date',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Flexible(
                              child: Text(
                                'Stock Location',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                        rows: snapshot.data!.docs.map((doc) {
                          final orderStatus = doc['order_status'].toString();
                          return DataRow(
                            cells: [
                              DataCell(Text(doc['order_id'].toString())),
                              DataCell(Text(doc['order_amount'].toString())),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: getStatusColor(orderStatus),
                                  child: Text(
                                    orderStatus,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              DataCell(Text(formatTimestamp(
                                  doc['order_date'] as Timestamp?))),
                              DataCell(Text(formatTimestamp(
                                  doc['deli_date'] as Timestamp?))),
                              DataCell(Text(
                                  doc['stock_location']?.toString() ?? '')),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No recent orders found.'));
        }
      },
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final DateTime date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }
}
