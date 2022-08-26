import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enums/product/prod_condition_enum.dart';
import '../../enums/product/prod_delivery_type.dart';
import '../../enums/product/prod_privacy_type.dart';
import '../../providers/product/app_product_provider.dart';
import '../../utilities/custom_validator.dart';
import '../custom_widgets/custom_textformfield.dart';
import '../custom_widgets/text_between_lines.dart';
import '../custom_widgets/title_text.dart';
import 'radio_widgets/prod_accept_offer_widget.dart';
import 'radio_widgets/prod_condition_widget.dart';
import 'radio_widgets/prod_delivery_type_widget.dart';
import 'radio_widgets/prod_privacy_widget.dart';

class AddProdAdditionalInfo extends StatelessWidget {
  const AddProdAdditionalInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductProvider>(
      builder: (BuildContext context, AddProductProvider addPro, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TextBetweenLines(title: 'additional information'),
            const SizedBox(height: 10),
            FittedBox(
              child: CustomTitleText(
                  title: 'Select the Condition of your product'.toUpperCase()),
            ),
            ProdConditionWidget(
              condition: addPro.condition,
              onChanged: (ProdConditionEnum? value) =>
                  addPro.onConditionUpdate(value),
            ),
            CustomTitleText(title: 'Accept Offer'.toUpperCase()),
            ProdAcceptOfferWidget(
              onChanged: (bool value) => addPro.onAcceptOfferUpdate(value),
              acceptOffer: addPro.acceptOffer,
            ),
            CustomTitleText(title: 'Privacy'.toUpperCase()),
            ProdPrivacyWidget(
                privacy: addPro.privacy,
                onChanged: (ProdPrivacyTypeEnum? value) =>
                    addPro.onPrivacyUpdate(value)),
            CustomTitleText(title: 'Delivery Type'.toUpperCase()),
            ProdDeliveryTypeWidget(
              type: addPro.delivery,
              onChanged: (ProdDeliveryTypeEnum? value) =>
                  addPro.onDeliveryTypeUpdate(value),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Delivery Fee'.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: CustomTextFormField(
                    controller: addPro.deliveryFee,
                    showSuffixIcon: false,
                    validator: (String? value) =>
                        CustomValidator.isEmpty(value),
                    readOnly:
                        addPro.delivery == ProdDeliveryTypeEnum.collocation,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    color: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Please note that all delivery must be track and signed for. Please keep that in account when deciding delivery fee.\nThank you.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
