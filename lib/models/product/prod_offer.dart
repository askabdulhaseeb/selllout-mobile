// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../enums/product/prod_delivery_type.dart';
import '../../enums/product/prod_offer_status.dart';

class ProdOffer {
  ProdOffer({
    required this.uid,
    required this.chatId,
    required this.price,
    required this.deliveryType,
    required this.orderTime,
    required this.approvalTime,
    required this.status,
  });

  final String uid;
  final String chatId;
  double price;
  final ProdDeliveryTypeEnum deliveryType;
  final int orderTime;
  int approvalTime;
  ProdOfferStatusEnum status;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'chat_id': chatId,
      'price': price + 0.0,
      'deliveryType':
          ProdDeliveryTypeEnumConvertor.enumToString(delivery: deliveryType),
      'orderTime': orderTime,
      'approvalTime': approvalTime,
      'status': ProdOfferStatusEnumConvertor.toMap(status),
    };
  }

  factory ProdOffer.fromMap(Map<String, dynamic> map) {
    return ProdOffer(
      uid: map['uid'] ?? '',
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
