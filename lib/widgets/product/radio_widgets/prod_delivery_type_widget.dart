import 'package:flutter/material.dart';

import '../../../enums/product/prod_delivery_type.dart';

class ProdDeliveryTypeWidget extends StatelessWidget {
  const ProdDeliveryTypeWidget({
    required this.onChanged,
    required this.type,
    Key? key,
  }) : super(key: key);
  final void Function(ProdDeliveryTypeEnum?)? onChanged;
  final ProdDeliveryTypeEnum? type;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () => onChanged!(ProdDeliveryTypeEnum.delivery),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<ProdDeliveryTypeEnum>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: ProdDeliveryTypeEnum.delivery,
                groupValue: type,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (ProdDeliveryTypeEnum? value) => onChanged!(value),
              ),
              const Text('Delivery'),
            ],
          ),
        ),
        InkWell(
          onTap: () => onChanged!(ProdDeliveryTypeEnum.collocation),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<ProdDeliveryTypeEnum>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: ProdDeliveryTypeEnum.collocation,
                groupValue: type,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (ProdDeliveryTypeEnum? value) => onChanged!(value),
              ),
              const Text('Collection'),
            ],
          ),
        ),
        InkWell(
          onTap: () => onChanged!(ProdDeliveryTypeEnum.both),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<ProdDeliveryTypeEnum>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: ProdDeliveryTypeEnum.both,
                groupValue: type,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (ProdDeliveryTypeEnum? value) => onChanged!(value),
              ),
              const Text('Both'),
            ],
          ),
        ),
      ],
    );
  }
}
