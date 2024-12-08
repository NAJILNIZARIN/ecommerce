class Product {
  String? key;
  ProductData? productData;

  Product({this.key, this.productData});

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'productData': productData?.toJson(),
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      key: json['key'] as String?,
      productData: json['productData'] != null
          ? ProductData.fromJson(json['productData'])
          : null,
    );
  }
}

class ProductData {
  String? name;
  String? imageUrl;
  String? price;

  ProductData({this.name, this.imageUrl, this.price});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      price: json['price']?.toString(),
    );
  }
}
