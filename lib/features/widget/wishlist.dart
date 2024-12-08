import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../home/modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WishlistManager {
  static final List<Product> wishlist = [];
}

class CartModel {
  static List<Product> cart = []; // This holds the products in the cart.

  static void addToCart(Product product) {
    cart.add(product);
  }

  static void removeFromCart(Product product) {
    cart.remove(product);
  }

  static List<Product> getCart() {
    return cart;
  }
}
