import 'package:flutter/material.dart';
import '../Model/product_model.dart';

class CheckoutScreen extends StatelessWidget {
  final List<Product> cartItems;

  CheckoutScreen({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    double totalAmount = cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

    final _shippingController = TextEditingController();
    final _paymentController = TextEditingController();

    Future<void> _placeOrder() async {
      final shippingAddress = _shippingController.text;
      final paymentMethod = _paymentController.text;

      if (shippingAddress.isEmpty || paymentMethod.isEmpty) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      // Here you would typically send the order details to your API
      // For now, let's just show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order placed successfully')),
      );

      // Navigate back to the product list or home screen
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _shippingController,
              decoration: InputDecoration(labelText: 'Shipping Address'),
              // Add validation if needed
            ),
            TextFormField(
              controller: _paymentController,
              decoration: InputDecoration(labelText: 'Payment Method'),
              // Add validation if needed
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _placeOrder,
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
