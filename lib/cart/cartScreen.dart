import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../features/widget/custom_bottomNavigationBar.dart';
import '../features/widget/wishlist.dart';

class CartScreen extends StatefulWidget {
  final int currentIndex;

  const CartScreen({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  // Method to calculate the total price of the items in the cart
  double getTotalPrice() {
    double total = 0.0;
    for (var product in CartModel.cart) {
      // Ensure price is a valid num (either double or int)
      Object price = product.productData?.price ?? 0.0;

      // Add price to total (convert to double if needed)
      total += price is num ? price.toDouble() : 0.0; // Convert to double explicitly
    }
    return total;
  }

  void openCheckout(double amount) async {
    // Explicitly cast amount to num (either int or double)
    num amountInPaise = (amount * 100).toInt(); // Convert to paise and ensure it's an integer
    var options = {
      'key': 'rzp_test_1DP5mm0lF5G5ag', // Your Razorpay key
      'name': 'NJL',
      'prefill': {'contact': '9037367280', 'email': 'najil@gmail.com'},
      'external': {'wallets': ['paytm']},
      'amount': amountInPaise, // Pass the amount in paise (num type)
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('error : $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment success: ${response.paymentId}',
        toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment fail: ${response.message}',
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'External wallet: ${response.walletName}',
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = getTotalPrice();
    amtController.text = totalPrice.toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: CartModel.cart.length,
              itemBuilder: (context, index) {
                final product = CartModel.cart[index];

                return ListTile(
                  leading: Image.network(
                    product.productData?.imageUrl ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.productData?.name ?? 'Product'),
                  subtitle: Text('Price: ${product.productData?.price ?? 'No Price'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        CartModel.removeFromCart(product);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Price:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Display the total price in a TextField
                // SizedBox(
                //   width: 120,
                //   child: TextField(
                //     controller: amtController, // Set controller
                //     keyboardType: TextInputType.numberWithOptions(decimal: true),
                //     decoration: const InputDecoration(
                //       border: OutlineInputBorder(),
                //       hintText: 'Enter Amount',
                //     ),
                //     onChanged: (value) {
                //       // You can handle the updated value here if needed
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                double amount = double.tryParse(amtController.text) ?? 0.0;
                print('Proceeding to checkout with ${CartModel.cart.length} items');
                openCheckout(amount);
              },
              child: const Text('Proceed to Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomBottomNavBar(
            currentIndex: widget.currentIndex,
          ),
        ],
      ),
    );
  }
}
