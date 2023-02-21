import 'package:flutter/material.dart';

import '../../utilities/dimensions.dart';

class ProfileVisibilityType extends StatelessWidget {
  const ProfileVisibilityType({
    required this.isPublic,
    required this.onChanged,
    Key? key,
  }) : super(key: key);
  final bool isPublic;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 16),
        const Text(
          'Gender',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault,),
        InkWell(
          onTap: () => onChanged!(true),
          child: Container(height: 50,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withOpacity(.2),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio<bool>(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: true,
                  activeColor: Theme.of(context).primaryColor,
                  groupValue: isPublic,
                  onChanged: (bool? value) => onChanged!(true),
                ),
                const Text('Male', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault,),
        InkWell(
          onTap: () => onChanged!(false),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(.2),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio<bool>(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: false,
                  activeColor: Theme.of(context).primaryColor,
                  groupValue: isPublic,
                  onChanged: (bool? value) => onChanged!(false),
                ),
                const Text('Female', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
