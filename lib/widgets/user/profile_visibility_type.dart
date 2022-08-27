import 'package:flutter/material.dart';

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
          'Profile Display',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        InkWell(
          onTap: () => onChanged!(true),
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
              const Text('PUBLIC', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        InkWell(
          onTap: () => onChanged!(false),
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
              const Text('PRIVATE', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
