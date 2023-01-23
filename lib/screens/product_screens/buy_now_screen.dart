import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:selllout/helper/payment_helper.dart';
import 'package:selllout/utilities/utilities.dart';

import '../../enums/product/prod_delivery_type.dart';
import '../../models/product/product.dart';
import '../../providers/product/product_provider.dart';
import '../../utilities/app_image.dart';
import '../../widgets/product/prod_urls_slider.dart';
import 'payment_success_screen.dart';

class BuyNowScreen extends StatelessWidget {
  const BuyNowScreen({required this.product, Key? key}) : super(key: key);
  static const String routeName = '/buy-now-screen';
  final Product product;

  @override
  Widget build(BuildContext context) {
    void onApplePayResult(paymentResult) {
      debugPrint(paymentResult.toString());
    }
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Product_Info(product: product),
            const SizedBox(height: 16),
            const Text(
              'Select a payment method',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _ImageIconButton(
                  imagePath: AppImages.paypal,
                  title: 'PayPal',
                  onTap: () {
                    PaymentHelper.makePayment(context,
                      product.price,Utilities.payments[0],
                    );
                    // _sendOrder(context);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute<PaymentSuccessScreen>(
                    //     builder: (_) => const PaymentSuccessScreen(),
                    //   ),
                    // );
                  },
                ),
                _ImageIconButton(
                  imagePath: AppImages.strip,
                  title: 'Strip',
                  onTap: () {
                     PaymentHelper.makePayment(context,
                       product.price, Utilities.payments[1],
                    );
                    // _sendOrder(context);
                    // Navigator.of(context).push(
                    //   MaterialPageRoute<PaymentSuccessScreen>(
                    //     builder: (_) => const PaymentSuccessScreen(),
                    //   ),
                    // );
                  },
                ),
                ApplePayButton(
                  paymentConfigurationAsset: 'default_payment_profile_apple_pay.json',
                  paymentItems: [PaymentItem(
                    label: 'Total',
                    amount: product.price.toString(),
                    status: PaymentItemStatus.final_price,
                  )
                  ],
                  style: ApplePayButtonStyle.black,
                  type: ApplePayButtonType.buy,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: onApplePayResult,
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                // _ImageIconButton(
                //   imagePath: AppImages.applePay,
                //   title: 'Apple Pay',
                //   onTap: () {
                //     _sendOrder(context);
                //     Navigator.of(context).push(
                //       MaterialPageRoute<PaymentSuccessScreen>(
                //         builder: (_) => const PaymentSuccessScreen(),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _sendOrder(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .sendOrder(context, product);
  }
}

class _ImageIconButton extends StatelessWidget {
  const _ImageIconButton({
    required this.imagePath,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 50,
                width: 50,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class _Product_Info extends StatelessWidget {
  const _Product_Info({required this.product, Key? key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    const double imageSize = 140;
    return SizedBox(
      height: imageSize + 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: imageSize,
            height: imageSize,
            child: Hero(
              tag: product.pid,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ProductURLsSlider(
                  urls: product.prodURL,
                  width: imageSize,
                  height: imageSize,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SelectableText(
                    product.title,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Type: ${ProdDeliveryTypeEnumConvertor.enumToString(
                      delivery: product.delivery,
                    )}',
                  ),
                  Expanded(
                    child: FittedBox(
                      child: Text(
                        product.price.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];