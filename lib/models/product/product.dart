import 'package:cloud_firestore/cloud_firestore.dart';

import '../../enums/product/prod_condition_enum.dart';
import '../../enums/product/prod_delivery_type.dart';
import '../../enums/product/prod_privacy_type.dart';
import 'product_url.dart';

class Product {
  Product({
    required this.pid,
    required this.uid,
    required this.title,
    required this.prodURL,
    required this.thumbnail,
    required this.condition,
    required this.description,
    required this.categories,
    required this.subCategories,
    required this.price,
    this.currency = 'EUR',
    this.location,
    this.quantity = 1,
    this.acceptOffers = true,
    this.privacy = ProdPrivacyTypeEnum.public,
    this.delivery = ProdDeliveryTypeEnum.delivery,
    this.deliveryFree = 0,
    this.timestamp,
    this.isAvailable = true,
  });

  late String pid;
  late String uid;
  late String title;
  late List<ProductURL> prodURL;
  late String thumbnail;
  late ProdConditionEnum condition;
  late String description;
  late List<String> categories;
  late List<String> subCategories;
  late double price;
  late String currency;
  late String? location;
  late int quantity;
  late bool acceptOffers;
  late ProdPrivacyTypeEnum privacy;
  late ProdDeliveryTypeEnum delivery;
  late double deliveryFree;
  late int? timestamp;
  late bool isAvailable; // available for sale any more are not

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pid': pid,
      'uid': uid,
      'title': title,
      'prod_urls': prodURL.map((ProductURL e) => e.toMap()).toList(),
      'thumbnail': thumbnail,
      'condition':
          ProdConditionEnumConvertor.enumToString(condition: condition),
      'description': description,
      'categories': categories,
      'sub_categories': subCategories,
      'price': price,
      'currency': currency,
      'quantity': quantity,
      'accept_offers': acceptOffers,
      'privacy': ProdPrivacyTypeEnumConvertor.enumToString(privacy: privacy),
      'delivery': ProdDeliveryTypeEnumConvertor.enumToString(delivery: delivery),
      'delivery_free': deliveryFree,
      'timestamp': timestamp,
      'is_available': isAvailable,
    };
  }

  // ignore: sort_constructors_first
  factory Product.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    List<ProductURL> prodURL = <ProductURL>[];
    doc.data()!['prodURL'].forEach((dynamic e) {
      prodURL.add(ProductURL.fromMap(e));
    });
    return Product(
      pid: doc.data()!['pid'] ?? '',
      uid: doc.data()!['uid'] ?? '',
      title: doc.data()!['title'] ?? '',
      prodURL: prodURL,
      thumbnail: doc.data()!['thumbnail'] ?? '',
      condition: ProdConditionEnumConvertor.stringToEnum(
          condition: doc.data()!['condition']),
      description: doc.data()!['description'] ?? '',
      categories: List<String>.from(doc.data()!['categories']),
      subCategories: List<String>.from(doc.data()!['sub_categories']),
      price: doc.data()!['price']?.toDouble() ?? 0.0,
      currency: doc.data()!['currency'] ?? 'EUR',
      location: doc.data()!['location'] ?? 'location not found',
      quantity: doc.data()!['quantity']?.toInt() ?? 0,
      acceptOffers: doc.data()!['accept_offers'] ?? false,
      privacy: ProdPrivacyTypeEnumConvertor.stringToEnum(
          privacy: doc.data()!['privacy']),
      delivery: ProdDeliveryTypeEnumConvertor.stringToEnum(
          delivery: doc.data()!['delivery']),
      deliveryFree: doc.data()!['delivery_free']?.toDouble() ?? 0.0,
      timestamp: doc.data()!['timestamp']?.toInt(),
      isAvailable: doc.data()!['is_available'] ?? false,
    );
  }
}
