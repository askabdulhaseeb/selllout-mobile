// ignore_for_file: constant_identifier_names
enum ProdDeliveryTypeEnum { delivery, collocation, both }

class ProdDeliveryTypeEnumConvertor {
  static String enumToString({required ProdDeliveryTypeEnum delivery}) {
    if (delivery == ProdDeliveryTypeEnum.delivery) {
      return 'delivery';
    } else if (delivery == ProdDeliveryTypeEnum.collocation) {
      return 'collocation';
    } else {
      return 'both';
    }
  }

  static ProdDeliveryTypeEnum stringToEnum({required String delivery}) {
    if (delivery == 'delivery') {
      return ProdDeliveryTypeEnum.delivery;
    } else if (delivery == 'collocation') {
      return ProdDeliveryTypeEnum.collocation;
    } else {
      return ProdDeliveryTypeEnum.both;
    }
  }
}