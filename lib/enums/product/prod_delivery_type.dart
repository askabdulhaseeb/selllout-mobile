// ignore_for_file: constant_identifier_names
enum DeliveryTypeEnum { delivery, collocation, both }

class DeliveryTypeEnumConvertor {
  static String enumToString({required DeliveryTypeEnum delivery}) {
    if (delivery == DeliveryTypeEnum.delivery) {
      return 'delivery';
    } else if (delivery == DeliveryTypeEnum.collocation) {
      return 'collocation';
    } else {
      return 'both';
    }
  }

  static DeliveryTypeEnum stringToEnum({required String delivery}) {
    if (delivery == 'delivery') {
      return DeliveryTypeEnum.delivery;
    } else if (delivery == 'collocation') {
      return DeliveryTypeEnum.collocation;
    } else {
      return DeliveryTypeEnum.both;
    }
  }
}