import '../../enums/product/prod_delivery_type.dart';
import '../../enums/product/prod_offer_status.dart';

class ProdOffer {
  ProdOffer({
    required this.uid,
    required this.offerID,
    required this.chatId,
    required this.price,
    required this.deliveryType,
    required this.orderTime,
    required this.approvalTime,
    required this.status,
  });

  final String uid;
  final String offerID;
  final String chatId;
  double price;
  final ProdDeliveryTypeEnum deliveryType;
  final int orderTime;
  int approvalTime;
  ProdOfferStatusEnum status;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'offer_id': offerID,
      'chat_id': chatId,
      'price': price + 0.0,
      'deliveryType':
          ProdDeliveryTypeEnumConvertor.enumToString(delivery: deliveryType),
      'orderTime': orderTime,
      'approvalTime': approvalTime,
      'status': ProdOfferStatusEnumConvertor.toMap(status),
    };
  }

  // ignore: sort_constructors_first
  factory ProdOffer.fromMap(Map<String, dynamic> map) {
    return ProdOffer(
      uid: map['uid'] ?? '',
      offerID: map['offer_id'] ??
          map['uid'] + map['price'].toString() + map['orderTime'].toString(),
      chatId: map['chat_id'] ?? '',
      price: map['price'] + 0.0,
      deliveryType: ProdDeliveryTypeEnumConvertor.stringToEnum(
          delivery: map['deliveryType'] ?? 'delivery'),
      orderTime: map['orderTime'] ?? 0,
      approvalTime: map['approvalTime'] ?? 0,
      status: ProdOfferStatusEnumConvertor.fromMap(map['status'] ?? 'pending'),
    );
  }
}
