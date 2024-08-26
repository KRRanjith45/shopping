import 'package:shared_preferences/shared_preferences.dart';

Future<void> _saveCheckoutDetails(double totalAmount, String shippingAddress) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setDouble('totalAmount', totalAmount);
  prefs.setString('shippingAddress', shippingAddress);
}


