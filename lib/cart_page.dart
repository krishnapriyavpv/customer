import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Error: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 15000, // Amount in paise (e.g., 15000 paise = ₹150.00)
      'name': 'Test Shop',
      'description': 'Payment for cart items',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is your Cart Page!',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: _startPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4F5A), // Customize the color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const SizedBox(
                width: 200,
                child: Center(
                  child: Text(
                    'Pay with Razorpay',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
