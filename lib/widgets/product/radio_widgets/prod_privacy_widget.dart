import 'package:flutter/material.dart';
import '../../../enums/product/prod_privacy_type.dart';

class ProdPrivacyWidget extends StatelessWidget {
  const ProdPrivacyWidget({
    required this.onChanged,
    required this.privacy,
    this.mainAxisAlignment = MainAxisAlignment.start,
    Key? key,
  }) : super(key: key);
  final void Function(ProdPrivacyTypeEnum?)? onChanged;
  final ProdPrivacyTypeEnum? privacy;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: <Widget>[
        InkWell(
          onTap: () => onChanged!(ProdPrivacyTypeEnum.public),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<ProdPrivacyTypeEnum>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: ProdPrivacyTypeEnum.public,
                groupValue: privacy,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (ProdPrivacyTypeEnum? value) => onChanged!(value),
              ),
              const Text('Public'),
            ],
          ),
        ),
        InkWell(
          onTap: () => onChanged!(ProdPrivacyTypeEnum.supporters),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<ProdPrivacyTypeEnum>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: ProdPrivacyTypeEnum.supporters,
                groupValue: privacy,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (ProdPrivacyTypeEnum? value) => onChanged!(value),
              ),
              const Text('Supporters'),
            ],
          ),
        ),
        InkWell(
          onTap: () => onChanged!(ProdPrivacyTypeEnum.private),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<ProdPrivacyTypeEnum>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: ProdPrivacyTypeEnum.private,
                groupValue: privacy,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (ProdPrivacyTypeEnum? value) => onChanged!(value),
              ),
              const Text('Private'),
            ],
          ),
        ),
      ],
    );
  }
}
