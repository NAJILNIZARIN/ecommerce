import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../productDetail/product_detail_view.dart';
import '../widget/custom_bottomNavigationBar.dart';
import 'modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<Product> productList = [];
  List<Product> filteredProductList = [];
  int _currentIndex = 0;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieveProductData();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProducts);
    super.dispose();
  }

  void _filterProducts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredProductList = productList
          .where((product) => product.productData?.name
          ?.toLowerCase()
          .contains(query) ??
          false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width/1.2,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Products...',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: filteredProductList.isEmpty
            ? productList.length
            : filteredProductList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(_createPageRoute(
                ProductDetailPage(product: filteredProductList.isEmpty
                    ? productList[index]
                    : filteredProductList[index], currentIndex: 0,),
              ));
            },
            child: productWidget(filteredProductList.isEmpty
                ? productList[index]
                : filteredProductList[index]),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
      ),
    );
  }

  Widget productWidget(Product product) {
    return Card(
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: product.productData?.imageUrl != null
                    ? Image.network(
                  product.productData!.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported, size: 50),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                )
                    : const Icon(Icons.image_not_supported, size: 50),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              product.productData?.name ?? 'No Name',
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Price: ${product.productData?.price ?? 'No Price'}',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void retrieveProductData() {
    dbRef.child("Product").onChildAdded.listen((data) {
      Map<String, dynamic> productDataMap = Map<String, dynamic>.from(data.snapshot.value as Map);

      ProductData productData = ProductData.fromJson(productDataMap);

      Product product = Product(key: data.snapshot.key, productData: productData);
      productList.add(product);
      filteredProductList.add(product);

      setState(() {});
    });
  }

  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
