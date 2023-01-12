import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../database/product_api.dart';
import '../../enums/product/prod_condition_enum.dart';
import '../../enums/product/prod_offer_status.dart';
import '../../functions/time_date_functions.dart';
import '../../functions/unique_id_functions.dart';
import '../../models/app_user.dart';
import '../../models/product/prod_offer.dart';
import '../../models/product/prod_order.dart';
import '../../models/product/product.dart';
import '../../models/product/product_url.dart';
import '../provider.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider() {
    _load();
  }
  Future<void> report(Product product) async {
    final int index =
        _products.indexWhere((Product element) => element.pid == product.pid);
    if (index < 0) return;
    _products[index] = product;
    notifyListeners();
    await ProductAPI().report(product);
  }

  List<Product> userProducts(String uid) {
    final List<Product> temp = <Product>[];
    for (Product element in _products) {
      if (element.uid == uid) temp.add(element);
    }
    return temp;
  }

  Product product(String pid) {
    final int index =
        _products.indexWhere((Product element) => element.pid == pid);
    return (index < 0) ? _null : _products[index];
  }

  Future<void> sendOrder(BuildContext context, Product value) async {
    final String me = AuthMethods.uid;
    if (value.uid == me) return;
    final int index = _indexOf(value.pid);
    if (index < 0) return;
    final ProdOrder order = ProdOrder(
      uid: me,
      price: value.price,
      deliveryType: value.delivery,
      orderTime: TimeDateFunctions.timestamp,
      approvalTime: TimeDateFunctions.timestamp,
    );
    _products[index].orders?.add(order);
    final UserProvider userPro = Provider.of(context, listen: false);
    final AppUser sender = userPro.user(uid: me);
    final AppUser receiver = userPro.user(uid: value.uid);
    await ProductAPI().sendOrder(
      product: _products[index],
      sender: sender,
      receiver: receiver,
    );
  }

  Future<void> sendOffer({
    required Product value,
    required String chatID,
    required double amount,
    required BuildContext context,
  }) async {
    final String me = AuthMethods.uid;
    if (value.uid == me) return;
    final int index = _indexOf(value.pid);
    if (index < 0) return;
    final ProdOffer offer = ProdOffer(
      uid: me,
      offerID: UniqueIdFunctions.offerID,
      chatId: chatID,
      price: amount,
      deliveryType: value.delivery,
      orderTime: TimeDateFunctions.timestamp,
      approvalTime: TimeDateFunctions.timestamp,
      status: ProdOfferStatusEnum.pending,
    );
    _products[index].offers?.add(offer);
    final UserProvider userPro = Provider.of(context, listen: false);
    final AppUser sender = userPro.user(uid: me);
    final AppUser receiver = userPro.user(uid: value.uid);
    await ProductAPI().sendOffer(
      product: _products[index],
      sender: sender,
      receiver: receiver,
    );
  }

  Future<void> updateOffer({
    required String pid,
    required ProdOffer newOffer,
  }) async {
    await _load();
    final int index = _indexOf(pid);
    if (index < 0) return;
    _products[index].offers?.removeWhere(
        (ProdOffer element) => element.offerID == newOffer.offerID);
    _products[index].offers?.add(newOffer);
    notifyListeners();
    await ProductAPI().updateOffer(_products[index]);
  }

  List<Product> _products = <Product>[];
  bool _isLoading = true;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  List<Product> productsByUsers(AppUser me) {
    final List<String> supporting = me.supporting ?? <String>[];
    final List<String> blockedBy = me.blockedBy ?? <String>[];
    List<Product> tempProd = <Product>[];
    for (Product element in _products) {
      if (supporting.contains(element.uid) &&
          (!blockedBy.contains(element.uid))) {
        tempProd.add(element);
      }
    }
    if (tempProd.isEmpty) {
      for (Product element in _products) {
        if (!blockedBy.contains(element.uid)) {
          tempProd.add(element);
        }
      }
    }
    return tempProd.isEmpty ? _products : tempProd;
  }

  Future<void> init() async {
    if (_products.isNotEmpty) return;
    await _load();
  }

  Future<void> refresh() async {
    await _load();
  }

  Future<void> _load() async {
    List<Product> temp = await ProductAPI().getProducts();
    _products = temp;
    _isLoading = false;
    notifyListeners();
  }

  int _indexOf(String pid) {
    return _products.indexWhere((Product element) => element.pid == pid);
  }

  Product get _null => Product(
        pid: '0',
        uid: AuthMethods.uid,
        title: AuthMethods.uid,
        prodURL: <ProductURL>[ProductURL(url: '', isVideo: false, index: 0)],
        thumbnail: '',
        condition: ProdConditionEnum.NEW,
        description: 'description',
        categories: <String>[''],
        subCategories: <String>[''],
        price: 0,
      );
}
