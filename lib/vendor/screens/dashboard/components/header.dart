import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/vendor/controllers/menu_app_controller.dart';
import 'package:customer/vendor/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        Expanded(
            child: ElevatedButton.icon(
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: const Text(
            "Add Product",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AddProductPopup(),
            );
          },
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(10, 45),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10), // Rounded corners with radius 10
            ),
          ),
        )),
        const SizedBox(
          height: 10,
        ),
        // Expanded(
        //     child: ElevatedButton(
        //         onPressed: () {},
        //         style: ElevatedButton.styleFrom(
        //           fixedSize: const Size(25, 45),
        //           backgroundColor: Colors.grey,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(
        //                 10), // Rounded corners with radius 10
        //           ),
        //         ),
        //         child: const Text("Log Out")))
      ],
    );
  }
}

class AddProductPopup extends StatefulWidget {
  const AddProductPopup({super.key});

  @override
  AddProductPopupState createState() => AddProductPopupState();
}

class AddProductPopupState extends State<AddProductPopup> {
  final _formKey = GlobalKey<FormState>();
  String location = '';
  String prodName = '';
  String prodId = '';
  double unitPrice = 0.0;
  int quantity = 0;
  bool _isLoading = false; // Loading indicator state

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await FirebaseFirestore.instance.collection('inventory_list').add({
        'location': location,
        'prod_name': prodName,
        'prod_id': prodId,
        'unit_price': unitPrice,
        'quantity': quantity,
        'inventory_value': unitPrice * quantity,
      }).then((value) {
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Product"),
      content: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Location"),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a location' : null,
                    onChanged: (value) => location = value,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Product Name"),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a product name' : null,
                    onChanged: (value) => prodName = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Product ID"),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a product ID' : null,
                    onChanged: (value) => prodId = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Unit Price"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final parsedValue = double.tryParse(value!);
                      return parsedValue == null || parsedValue <= 0
                          ? 'Please enter a valid unit price'
                          : null;
                    },
                    onChanged: (value) => unitPrice = double.parse(value),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Quantity"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final parsedValue = int.tryParse(value!);
                      return parsedValue == null || parsedValue <= 0
                          ? 'Please enter a valid quantity'
                          : null;
                    },
                    onChanged: (value) => quantity = int.parse(value),
                  ),
                ],
              ),
            ),
      actions: [
        ElevatedButton(
          onPressed: _submitForm,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Submit"),
        ),
      ],
    );
  }
}


// class ProfileCard extends StatelessWidget {
//   const ProfileCard({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: defaultPadding),
//       padding: const EdgeInsets.symmetric(
//         horizontal: defaultPadding,
//         vertical: defaultPadding / 2,
//       ),
//       decoration: BoxDecoration(
//         color: secondaryColor,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(color: Colors.white10),
//       ),
//       child: Row(
//         children: [
//        \
//           if (!Responsive.isMobile(context))
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
//               child: Text("Angelina Jolie"),
//             ),
//           const Icon(Icons.keyboard_arrow_down),
//         ],
//       ),
//     );
//   }
// }

// // class SearchField extends StatelessWidget {
// //   const SearchField({
// //     super.key,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return TextField(
// //       decoration: InputDecoration(
// //         hintText: "Search",
// //         fillColor: secondaryColor,
// //         filled: true,
// //         border: const OutlineInputBorder(
// //           borderSide: BorderSide.none,
// //           borderRadius: BorderRadius.all(Radius.circular(10)),
// //         ),
// //         suffixIcon: InkWell(
// //           onTap: () {},
// //           child: Container(
// //             padding: const EdgeInsets.all(defaultPadding * 0.75),
// //             margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
// //             decoration: const BoxDecoration(
// //               color: primaryColor,
// //               borderRadius: BorderRadius.all(Radius.circular(10)),
// //             ),
// //             child: SvgPicture.asset("assets/icons/Search.svg"),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

