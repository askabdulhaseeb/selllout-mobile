import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/auth_methods.dart';
import '../../database/product_api.dart';
import '../../enums/product/prod_condition_enum.dart';
import '../../enums/product/prod_delivery_type.dart';
import '../../enums/product/prod_privacy_type.dart';
import '../../functions/time_date_functions.dart';
import '../../models/product/product.dart';
import '../../models/product/product_url.dart';
import '../../utilities/custom_services.dart';
import '../../utilities/utilities.dart';
import '../../widgets/custom_widgets/custom_toast.dart';
import '../provider.dart';

class AddProductProvider extends ChangeNotifier {
  //
  // ON TAP FUNCTIONS
  //
  void onDeliveryTypeUpdate(ProdDeliveryTypeEnum? value) {
    if (value == null) return;
    if (value == ProdDeliveryTypeEnum.collocation) _deliveryFee.text = '0';
    _delivery = value;
    notifyListeners();
  }

  void onPrivacyUpdate(ProdPrivacyTypeEnum? value) {
    if (value == null) return;
    _privacy = value;
    notifyListeners();
  }

  void onAcceptOfferUpdate(bool value) {
    _acceptOffer = value;
    notifyListeners();
  }

  void onConditionUpdate(ProdConditionEnum? value) {
    if (value == null) return;
    _condition = value;
    notifyListeners();
  }

  Future<void> fetchMedia() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result == null) return;
    _files.clear();
    for (PlatformFile element in result.files) {
      _files.add(element);
    }
    for (int i = result.files.length; i < 10; i++) {
      _files.add(null);
    }
    notifyListeners();
  }

  onQuantityUpdate({required bool increase}) {
    if (_quantity.text.isEmpty) {
      _quantity.text = '0';
      return;
    }
    int num = int.parse(_quantity.text);

    if (increase) {
      num++;
    } else {
      if (num == 0) return;
      num--;
    }
    _quantity.text = num.toString();
    notifyListeners();
  }

  void onPost({required BuildContext context}) async {
    if (_key.currentState!.validate()) {
      if (_files[0] == null) {
        CustomToast.errorToast(message: 'Add Images of the product');
        return;
      }
      CustomService.dismissKeyboard();
      _isloading = true;
      notifyListeners();
      int timestamp = TimeDateFunctions.timestamp;
      String pid = AuthMethods.uid + timestamp.toString();
      ProdCatProvider catPro =
          Provider.of<ProdCatProvider>(context, listen: false);
      List<ProductURL> urls = <ProductURL>[];
      for (int i = 0; i < 10; i++) {
        if (_files[i] != null) {
          String? tempURL = await ProductAPI().uploadImage(
            pid: pid,
            file: File(_files[i]!.path!),
          );
          urls.add(
            ProductURL(
              url: tempURL ?? '',
              isVideo: Utilities.isVideo(extension: _files[i]!.extension!),
              index: i,
            ),
          );
        }
      }
      Product product = Product(
        pid: pid,
        uid: AuthMethods.uid,
        title: _title.text.trim(),
        prodURL: urls,
        thumbnail: '',
        condition: _condition,
        description: _description.text.trim(),
        categories: <String>[catPro.selectedCategroy?.catID ?? ''],
        subCategories: <String>[catPro.selectedSubCategory?.subCatID ?? ''],
        price: double.parse(_price.text),
        acceptOffers: _acceptOffer,
        privacy: _privacy,
        delivery: _delivery,
        deliveryFree: double.parse(_deliveryFee.text.trim()),
        quantity: int.parse(_quantity.text.trim()),
        isAvailable: true,
        timestamp: timestamp,
      );
      final bool uploaded = await ProductAPI().addProduct(product);
      _isloading = false;
      if (uploaded) {
        // ignore: use_build_context_synchronously
        Provider.of<AppProvider>(context, listen: false).onTabTapped(0);
        // ignore: use_build_context_synchronously
        await Provider.of<ProductProvider>(context).refresh();
        _reset();
        CustomToast.successToast(message: 'Uploaded Successfully');
      } else {
        CustomToast.errorToast(message: 'Error');
      }
    }
  }

  //
  // PRIVATE FUNCTIONS
  //
  void _reset() {
    _title.clear();
    _description.clear();
    _price.clear();
    _quantity.text = '1';
    _deliveryFee.text = '0';
    _condition = ProdConditionEnum.NEW;
    _privacy = ProdPrivacyTypeEnum.public;
    _delivery = ProdDeliveryTypeEnum.delivery;
    _files.clear();
    for (int i = 0; i < 10; i++) {
      _files.add(null);
    }
    notifyListeners();
  }

  //
  // VAIABLES
  //
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: prefer_final_fields
  ProdConditionEnum _condition = ProdConditionEnum.NEW;
  ProdPrivacyTypeEnum _privacy = ProdPrivacyTypeEnum.public;
  ProdDeliveryTypeEnum _delivery = ProdDeliveryTypeEnum.delivery;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _quantity = TextEditingController(text: '1');
  final TextEditingController _deliveryFee = TextEditingController(text: '0');

  bool _acceptOffer = true;
  bool _isloading = false;

  final List<PlatformFile?> _files = <PlatformFile?>[
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ];

  //
  // getter
  //

  // ENUMS
  ProdConditionEnum get condition => _condition;
  ProdPrivacyTypeEnum get privacy => _privacy;
  ProdDeliveryTypeEnum get delivery => _delivery;

  // TEXT EDITING CONTROLLERS
  TextEditingController get title => _title;
  TextEditingController get description => _description;
  TextEditingController get price => _price;
  TextEditingController get quantity => _quantity;
  TextEditingController get deliveryFee => _deliveryFee;

  // VARIABLES
  bool get acceptOffer => _acceptOffer;
  bool get isloading => _isloading;

  // Files
  List<PlatformFile?> get files => <PlatformFile?>[..._files];

  // KEY
  GlobalKey<FormState> get key => _key;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
}
