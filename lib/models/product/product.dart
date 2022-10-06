import 'package:cloud_firestore/cloud_firestore.dart';

import '../../database/auth_methods.dart';
import '../../enums/product/prod_condition_enum.dart';
import '../../enums/product/prod_delivery_type.dart';
import '../../enums/product/prod_privacy_type.dart';
import '../reports/report_product.dart';
import 'prod_offer.dart';
import 'prod_order.dart';
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
    this.offersLimit = 0,
    this.orders,
    this.offers,
    this.reports,
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
  final int offersLimit;
  final List<ProdOrder>? orders;
  final List<ProdOffer>? offers;
  final List<ReportProduct>? reports;
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
      'delivery':
          ProdDeliveryTypeEnumConvertor.enumToString(delivery: delivery),
      'delivery_free': deliveryFree,
      'offers_limit': acceptOffers == true ? quantity : offersLimit,
      'orders': orders,
      'offers': offers,
      'reports': <ReportProduct>[],
      'timestamp': timestamp,
      'is_available': isAvailable,
    };
  }

  Map<String, dynamic>? report() {
    if (reports == null) return null;
    return <String, dynamic>{
      'reports': FieldValue.arrayUnion(
          reports!.map((ReportProduct e) => e.toMap()).toList()),
    };
  }

  Map<String, dynamic> sendOrder() {
    return <String, dynamic>{
      'orders': FieldValue.arrayUnion(
          orders!.map((ProdOrder e) => e.toMap()).toList()),
    };
  }

  Map<String, dynamic> sendOffer() {
    return <String, dynamic>{
      'offers': FieldValue.arrayUnion(
          offers!.map((ProdOffer e) => e.toMap()).toList()),
    };
  }

  Map<String, dynamic> updateOffer() {
    return <String, dynamic>{
      'offers': offers!.map((ProdOffer e) => e.toMap()).toList(),
    };
  }

  // ignore: sort_constructors_first
  factory Product.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    List<ProductURL> prodURL = <ProductURL>[];
    List<ProdOrder> prodOrders = <ProdOrder>[];
    List<ProdOffer> prodOffers = <ProdOffer>[];
    doc.data()!['prod_urls'].forEach((dynamic e) {
      prodURL.add(ProductURL.fromMap(e));
    });
    List<ReportProduct> reportInfo = <ReportProduct>[];
    if (doc.data()!['reports'] != null) {
      final List<dynamic> temp = doc.data()!['reports'];
      for (dynamic e in temp) {
        reportInfo.add(ReportProduct.fromMap(e));
      }
    }
    if (doc.data()!['orders'] != null &&
        ((doc.data()!['uid'] ?? '') == AuthMethods.uid)) {
      final List<dynamic> temp = doc.data()!['orders'];
      for (dynamic e in temp) {
        prodOrders.add(ProdOrder.fromMap(e));
      }
    }

    if (doc.data()!['offers'] != null) {
      final List<dynamic> temp = doc.data()!['offers'];
      for (dynamic e in temp) {
        prodOffers.add(ProdOffer.fromMap(e));
      }
    }
    return Product(
      pid: doc.data()?['pid'] ?? '',
      uid: doc.data()?['uid'] ?? '',
      title: doc.data()?['title'] ?? '',
      prodURL: prodURL,
      thumbnail: doc.data()?['thumbnail'] ?? '',
      condition: ProdConditionEnumConvertor.stringToEnum(
          condition: doc.data()?['condition'] ?? 'NEW'),
      description: doc.data()?['description'] ?? '',
      categories: List<String>.from(doc.data()?['categories'] ?? <String>[]),
      subCategories:
          List<String>.from(doc.data()?['sub_categories'] ?? <String>[]),
      price: double.parse(doc.data()?['price'].toString() ?? '0.0'),
      currency: doc.data()?['currency'] ?? 'EUR',
      location: doc.data()?['location'] ?? 'location not found',
      quantity: int.parse(doc.data()?['quantity'].toString() ?? '0'),
      acceptOffers: doc.data()?['accept_offers'] ?? false,
      privacy: ProdPrivacyTypeEnumConvertor.stringToEnum(
          privacy: doc.data()?['privacy'] ?? 'public'),
      delivery: ProdDeliveryTypeEnumConvertor.stringToEnum(
          delivery: doc.data()?['delivery'] ?? 'delivery'),
      deliveryFree:
          double.parse(doc.data()?['delivery_free'].toString() ?? '0.0'),
      reports: reportInfo,
      offersLimit: doc.data()?['offers_limit'] ?? 0,
      orders: prodOrders,
      offers: prodOffers,
      timestamp: int.parse(doc.data()?['timestamp'].toString() ?? '0'),
      isAvailable: doc.data()?['is_available'] ?? false,
    );
  }
}
