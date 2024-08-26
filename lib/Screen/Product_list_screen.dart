import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/product_model.dart';
import 'Cart_screen.dart';


class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
        name: 'Coconutoil',
        description: 'Description 1',
        price: 100,
        img: "assets/images/coconutoil.jpg"),
    Product(
        name: 'Sunflower',
        description: 'Description 2',
        price: 200,
        img: "assets/images/sunflower.jpg"),
    // Add more products here
  ];

  Future<void> _saveProductToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cartItems') ?? [];

    // Convert product to JSON string
    String productJson = jsonEncode({
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'img': product.img,
      'quantity': product.quantity,
    });

    cartItems.add(productJson);
    await prefs.setStringList('cartItems', cartItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: products.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      product.img,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.shopping_cart, color: Colors.blue),
                      label: Text("Add to Cart"),
                      style: ElevatedButton.styleFrom(iconColor: Colors.blue),
                      onPressed: () async {
                        await _saveProductToCart(product);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CartScreen()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
