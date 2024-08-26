import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/Screen/Checkout_screen.dart';
import '../Model/product_model.dart'; // For decoding data

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartItemsJson = prefs.getStringList('cartItems') ?? [];

    setState(() {
      cartItems = cartItemsJson.map((item) {
        final productMap = jsonDecode(item);
        return Product(
          name: productMap['name'],
          description: productMap['description'],
          price: productMap['price'],
          img: productMap['img'],
          quantity: productMap['quantity'],
        );
      }).toList();
    });
  }

  void _increaseQuantity(Product product) {
    setState(() {
      product.quantity++;
      _saveCartItems(); // Save cart items after changing quantity
    });
  }

  void _decreaseQuantity(Product product) {
    setState(() {
      if (product.quantity > 1) {
        product.quantity--;
        _saveCartItems(); // Save cart items after changing quantity
      }
    });
  }

  void _removeItem(Product product) {
    setState(() {
      cartItems.remove(product);
      _saveCartItems(); // Save cart items after removing an item
    });
  }

  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItemsJson = cartItems.map((item) {
      return jsonEncode({
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'img': item.img,
        'quantity': item.quantity,
      });
    }).toList();
    await prefs.setStringList('cartItems', cartItemsJson);
  }

  double _getTotalAmount() {
    return cartItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                        '\$${product.price.toStringAsFixed(2)} x ${product.quantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            _decreaseQuantity(product);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _increaseQuantity(product);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _removeItem(product);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total Amount: \$${_getTotalAmount().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(cartItems: cartItems),
                      ),
                    );
                  },
                  child: Text('Proceed to Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
