import '../../enums/product/prod_delivery_type.dart';

class ProdOrder {
  ProdOrder({
    required this.uid,
    required this.price,
    required this.deliveryType,
    required this.orderTime,
    required this.approvalTime,
  });

  final String uid;
  final double price;
  final ProdDeliveryTypeEnum deliveryType;
  final int orderTime;
  final int approvalTime;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'price': price,
      'delivery_type':
          ProdDeliveryTypeEnumConvertor.enumToString(delivery: deliveryType),
      'order_time': orderTime,
      'approval_time': approvalTime,
    };
  }

  // ignore: sort_constructors_first
  factory ProdOrder.fromMap(Map<String, dynamic> map) {
    return ProdOrder(
      uid: map['uid'] as String,
      price: map['price'] as double,
      deliveryType: ProdDeliveryTypeEnumConvertor.stringToEnum(
          delivery: map['delivery_type'] ?? 'delivery'),
      orderTime: map['order_time'] as int,
      approvalTime: map['approval_time'] as int,
    );
  }
}
