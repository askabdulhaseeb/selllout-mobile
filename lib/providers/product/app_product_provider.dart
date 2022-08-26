import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../enums/product/prod_condition_enum.dart';
import '../../enums/product/prod_delivery_type.dart';
import '../../enums/product/prod_privacy_type.dart';
import '../../functions/unique_id_functions.dart';
import '../../utilities/custom_services.dart';
import '../../widgets/custom_widgets/custom_toast.dart';

class AddProductProvider extends ChangeNotifier {
  //
  // ON TAP FUNCTIONS
  //
  onDeliveryTypeUpdate(ProdDeliveryTypeEnum? value) {
    if (value == null) return;
    _delivery = value;
    notifyListeners();
  }

  onPrivacyUpdate(ProdPrivacyTypeEnum? value) {
    if (value == null) return;
    _privacy = value;
    notifyListeners();
  }

  onAcceptOfferUpdate(bool value) {
    _acceptOffer = value;
    notifyListeners();
  }

  onConditionUpdate(ProdConditionEnum? value) {
    if (value == null) return;
    _condition = value;
    notifyListeners();
  }

  fetchMedia() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.media,
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

  onPost() async {
    if (_key.currentState!.validate()) {
      if (_files[0] == null) {
        CustomToast.errorToast(message: 'Add Images of the product');
        return;
      }
      CustomService.dismissKeyboard();
      _isloading = true;
      notifyListeners();
      String pid = UniqueIdFunctions.postID;
    }
  }

  //
  // VAIABLES
  //
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
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
}
