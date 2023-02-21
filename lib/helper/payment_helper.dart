import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as Http;
import 'package:selllout/models/payment_model.dart';
import 'package:selllout/screens/payment/paypal/flutter_paypal.dart';


class PaymentHelper {

  static Future<PaymentResponse?> makePayment(BuildContext context, double total, PaymentModel payment) async {
    if(payment.paymentType == PaymentType.paypal) {
      return await payViaPaypal(context,total, payment);
    }else if(payment.paymentType == PaymentType.stripe) {
      return await payViaStripe(total, payment);
    }
    return PaymentResponse(isSuccess: false);
  }

  static Future<PaymentResponse?> payViaPaypal(BuildContext context, double total, PaymentModel payment) async {
    List<Map<String, dynamic>> _items = [];
    double _itemsPrice = 0;
    // for(CartModel item in cartList) {
    //   _itemsPrice += double.parse(item.prices.price);
    //   _items.add({
    //     "name": item.name,
    //     "quantity": item.quantity,
    //     "price": double.parse(item.prices.price).toStringAsFixed(2),
    //     "currency": Get.find<ConfigController>().getCurrency()
    //   });
    // }
    PaymentResponse? _paymentResponse;
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      UsePaypal _usePaypal = UsePaypal(
          sandboxMode: true,
          clientId:
          "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
          secretKey:
          "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
          returnURL: "https://samplesite.com/return",
          cancelURL: "https://samplesite.com/cancel",
          transactions: const [
            {
              "amount": {
                "total": '10.12',
                "currency": "USD",
                "details": {
                  "subtotal": '10.12',
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description":
              "The payment transaction description.",
              // "payment_options": {
              //   "allowed_payment_method":
              //       "INSTANT_FUNDING_SOURCE"
              // },
              "item_list": {
                "items": [
                  {
                    "name": "A demo product",
                    "quantity": 1,
                    "price": '10.12',
                    "currency": "USD"
                  }
                ],

                // shipping address is not required though
                "shipping_address": {
                  "recipient_name": "Jane Foster",
                  "line1": "Travis County",
                  "line2": "",
                  "city": "Austin",
                  "country_code": "US",
                  "postal_code": "73301",
                  "phone": "+00000000",
                  "state": "Texas"
                },
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            print("onSuccess: $params");
          },
          onError: (error) {
            print("onError: $error");
          },
          onCancel: (params) {
            print('cancelled: $params');
          });
      print('Paypal Data:========>${_usePaypal.transactions}');
      return _usePaypal;
    }));
    return _paymentResponse;
  }

  static Future<PaymentResponse?> payViaStripe(double total, PaymentModel payment) async {

    Stripe.publishableKey = payment.publishableKey!;
    Stripe.merchantIdentifier = 'my_stripe_payment';
    await Stripe.instance.applySettings();
    Map<String, dynamic> paymentIntentData;
    try {

      Map<String, dynamic> body = {
        'amount': (total * 100).toStringAsFixed(0),
        'currency': 'usd',
        'payment_method_types[]': 'card'
      };
      Http.Response _response = await Http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ${payment.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      paymentIntentData = jsonDecode(_response.body);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: true,
          googlePay: true,
          testEnv: true,
          merchantCountryCode: '+1',
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData['customer'],
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
        ));
        await Stripe.instance.presentPaymentSheet();
        print('Stripe Data:========>$paymentIntentData');
        return PaymentResponse(isSuccess: true, status: paymentIntentData['id']);
      }
    } on Exception catch (e) {
      if (e is StripeException) {
        return PaymentResponse(isSuccess: false, status: e.error.localizedMessage!);
      } else {
        return PaymentResponse(isSuccess: false, status: e.toString());
      }
    } catch (e) {
      return PaymentResponse(isSuccess: false, status: e.toString());
    }
    return null;
  }


}

class PaymentResponse {
  final bool isSuccess;
  final String status;
  PaymentResponse({required this.isSuccess, this.status = 'payment_failed_try_again'});
}