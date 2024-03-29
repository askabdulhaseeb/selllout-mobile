import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/app_user.dart';
import '../models/device_token.dart';
import '../models/product/product.dart';
import 'auth_methods.dart';
import 'notification_service.dart';

class ProductAPI {
  static const String _collection = 'products';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  // functions
  Future<Product?>? getProductByPID({required String pid}) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _instance.collection(_collection).doc(pid).get();
    if (doc.data() == null) return null;
    return Product.fromDoc(doc);
  }

  Future<List<Product>> getProductsByUID({required String uid}) async {
    List<Product> products = <Product>[];
    final QuerySnapshot<Map<String, dynamic>> doc = await _instance
        .collection(_collection)
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .get();
    for (DocumentSnapshot<Map<String, dynamic>> element in doc.docs) {
      products.add(Product.fromDoc(element));
    }
    return products;
  }

  Future<List<Product>> getProducts() async {
    List<Product> products = <Product>[];
    final QuerySnapshot<Map<String, dynamic>> doc = await _instance
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .get();
    for (DocumentSnapshot<Map<String, dynamic>> element in doc.docs) {
      products.add(Product.fromDoc(element));
    }
    return products;
  }

  Future<bool> report(Product product) async {
    try {
      final Map<String, dynamic>? value = product.report();
      if (value == null) return false;
      // ignore: always_specify_types
      await _instance.collection(_collection).doc(product.pid).update(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendOrder({
    required Product product,
    required AppUser sender,
    required AppUser receiver,
  }) async {
    try {
      await _instance
          .collection(_collection)
          .doc(product.pid)
          .update(product.sendOrder());
      if (receiver.deviceToken?.isNotEmpty ?? false) {
        await NotificationsServices().sendSubsceibtionNotification(
          deviceToken: receiver.deviceToken ?? <MyDeviceToken>[],
          messageTitle: 'New Product Order',
          messageBody: 'You receive an Order from ${sender.displayName}',
          data: <String>['product', 'order', sender.uid],
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendOffer({
    required Product product,
    required AppUser sender,
    required AppUser receiver,
  }) async {
    try {
      await _instance
          .collection(_collection)
          .doc(product.pid)
          .update(product.sendOffer());
      if (receiver.deviceToken?.isNotEmpty ?? false) {
        await NotificationsServices().sendSubsceibtionNotification(
          deviceToken: receiver.deviceToken ?? <MyDeviceToken>[],
          messageTitle: 'New Product Order',
          messageBody: 'You receive an Order from ${sender.displayName}',
          data: <String>['product', 'order', sender.uid],
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOffer(Product product) async {
    try {
      await _instance
          .collection(_collection)
          .doc(product.pid)
          .update(product.updateOffer());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      // ignore: always_specify_types
      await _instance
          .collection(_collection)
          .doc(product.pid)
          .set(product.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> uploadImage({required String pid, required File file}) async {
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref(
              'products/${AuthMethods.uid}/$pid/${DateTime.now().microsecondsSinceEpoch}')
          .putFile(file);
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }
}
