import 'package:flutter/material.dart';
import '../../../enums/product/prod_condition_enum.dart';

class ProdConditionWidget extends StatelessWidget {
  const ProdConditionWidget({
    required this.condition,
    required this.onChanged,
    Key? key,
  }) : super(key: key);
  final ProdConditionEnum condition;
  final void Function(ProdConditionEnum?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () => onChanged!(ProdConditionEnum.NEW),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<ProdConditionEnum>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: ProdConditionEnum.NEW,
                groupValue: condition,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (ProdConditionEnum? value) => onChanged!(value),
              ),
              const Text('New'),
              const SizedBox(width: 16),
            ],
          ),
        ),
        InkWell(
          onTap: () => onChanged!(ProdConditionEnum.USED),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<ProdConditionEnum>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: ProdConditionEnum.USED,
                groupValue: condition,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (ProdConditionEnum? value) => onChanged!(value),
              ),
              const Text('Used'),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}
