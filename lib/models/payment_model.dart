import 'package:flutter/material.dart';

enum PaymentType {
  paypal,
  stripe,
}

class PaymentModel {
  PaymentType paymentType;
  String icon;
  String title;
  String description;
  String? clientId;
  String? secretKey;
  String? publishableKey;
  String? keyId;
  String? publicKey;
  String? merchantKey;
  String? merchantMid;
  String? merchantWebsite;
  String? encryptionKey;

  PaymentModel({
    required this.paymentType,
    required this.icon,
    required this.title,
    required this.description,
    this.clientId,
    this.secretKey,
    this.publishableKey,
    this.keyId,
    this.publicKey,
    this.merchantKey,
    this.merchantMid,
    this.merchantWebsite,
    this.encryptionKey,
  });
}
