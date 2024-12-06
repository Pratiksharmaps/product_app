class Product {
  final String id;
  final String title;
  final String? subtitle;
  final String description;
  final String handle;
  final String thumbnail;
  final String status;
  final double priceStart;
  final double? priceEnd;
  final double? averageRating;
  final List<ProductVariant> variants;
  final List<ProductImage> productImages;
  final List<ProductReview> reviews;

  Product({
    required this.id,
    required this.title,
    this.subtitle,
    required this.description,
    required this.handle,
    required this.thumbnail,
    required this.status,
    required this.priceStart,
    this.priceEnd,
    this.averageRating,
    required this.variants,
    required this.productImages,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      handle: json['handle'],
      thumbnail: json['thumbnail'],
      status: json['status'],
      priceStart: json['priceStart'].toDouble(),
      priceEnd: json['priceEnd']?.toDouble(),
      averageRating: json['averageRating']?.toDouble(),
      variants: (json['variants'] as List).map((v) => ProductVariant.fromJson(v)).toList(),
      productImages: (json['productImages'] as List).map((i) => ProductImage.fromJson(i)).toList(),
      reviews: (json['reviews'] as List).map((r) => ProductReview.fromJson(r)).toList(),
    );
  }
}

class ProductVariant {
  final String id;
  final String title;
  final String sku;
  final double price;
  final double? specialPrice;
  final int inventoryQuantity;

  ProductVariant({
    required this.id,
    required this.title,
    required this.sku,
    required this.price,
    this.specialPrice,
    required this.inventoryQuantity,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      title: json['title'],
      sku: json['sku'],
      price: json['price'].toDouble(),
      specialPrice: json['specialPrice']?.toDouble(),
      inventoryQuantity: json['inventoryQuantity'],
    );
  }
}

class ProductImage {
  final String id;
  final String image;
  final int order;

  ProductImage({
    required this.id,
    required this.image,
    required this.order,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      image: json['image'],
      order: json['order'],
    );
  }
}

class ProductReview {
  final String id;
  final double rating;
  final String comment;
  final String createdAt;

  ProductReview({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      createdAt: json['createdAt'],
    );
  }
}

