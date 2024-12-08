import 'package:flutter/material.dart';
import '../home/modal.dart';
import '../widget/custom_bottomNavigationBar.dart';
import '../widget/wishlist.dart';

class WishlistPage extends StatefulWidget {
  final int currentIndex;

  const WishlistPage({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wishlist')),
      body: ListView.builder(
        itemCount: WishlistManager.wishlist.length,
        itemBuilder: (context, index) {
          final product = WishlistManager.wishlist[index];
          return ListTile(
            title: Text(product.productData?.name ?? 'Unknown'),
          );
        },
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
