import 'package:customer/vendor/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final CollectionReference _orderHistory =
      FirebaseFirestore.instance.collection('inventory_list');

  // Function to format timestamps
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return ''; // Return empty if null
    final DateTime date = timestamp.toDate();
    return DateFormat('dd-MM-yyyy').format(date); // Change format as needed
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
                      'Inventory List Page',
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
                            'ID',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          color: Colors.orange,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Product Name',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          color: Colors.purple,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Stock Location',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          color: Colors.purple,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Quantity',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          color: Colors.purple,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Unit Price',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          color: Colors.red,
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Inventory Value',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                    rows: snapshot.data!.docs.map((doc) {
                      return DataRow(
                        cells: [
                          DataCell(Text(doc['prod_id'].toString())),
                          DataCell(Text(doc['prod_name'].toString())),
                          DataCell(
                            Text(
                              doc["location"].toString(),
                            ),
                          ),
                          DataCell(Text(doc['quantity'].toString())),
                          DataCell(Text(doc['unit_price'].toString())),
                          DataCell(Text(doc['inventory_value']
                              .toString())), // Handle null value
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
            child: Text('Error: ${snapshot.error}',
                style: TextStyle(
                    color: Colors.white)), // Optional: Adjust error text color
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
