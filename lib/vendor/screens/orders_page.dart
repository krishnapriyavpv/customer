import 'package:customer/vendor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final CollectionReference _orderHistory =
      FirebaseFirestore.instance.collection('order_history');

  // Function to format timestamps
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return ''; // Return empty if null
    final DateTime date = timestamp.toDate();
    return DateFormat('dd-MM-yyyy').format(date); // Change format as needed
  }

  // Function to get color based on order status
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'placed':
        return Colors.blue;
      default:
        return Colors.grey; // Default color for unknown statuses
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _orderHistory.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'Order History Page',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  DataTable(
                    headingRowColor: WidgetStateProperty.all(primaryColor),
                    border: TableBorder.all(color: Colors.white),
                    columns: [
                      DataColumn(
                        label: Container(
                          color: Colors.blue,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Order ID',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      // Uncomment and customize the Product Name column if needed
                      // DataColumn(
                      //   label: Container(
                      //     color: Colors.green,
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: const Text(
                      //       'Product Name',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   ),
                      // ),
                      DataColumn(
                        label: Container(
                          color: Colors.orange,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Order Amount',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          color: Colors.purple,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Order Status',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          color: Colors.purple,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Order Date',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          color: Colors.purple,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Delivery Date',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          color: Colors.red,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
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
                          // Uncomment and customize the Product Name cell if needed
                          // DataCell(Text(doc['pro_name'].toString())),
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
                          DataCell(Text(
                              formatTimestamp(doc['deli_date'] as Timestamp?))),
                          DataCell(Text(doc['stock_location']?.toString() ??
                              '')), // Handle null value
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
