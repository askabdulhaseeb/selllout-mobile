import 'package:flutter/material.dart';

class ProdAcceptOfferWidget extends StatefulWidget {
  const ProdAcceptOfferWidget({
    required this.acceptOffer,
    required this.onChanged,
    Key? key,
  }) : super(key: key);
  final bool acceptOffer;
  final void Function(bool)? onChanged;
  @override
  State<ProdAcceptOfferWidget> createState() => _ProdAcceptOfferWidgetState();
}

class _ProdAcceptOfferWidgetState extends State<ProdAcceptOfferWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () => widget.onChanged!(true),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<bool>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: true,
                activeColor: Theme.of(context).primaryColor,
                groupValue: widget.acceptOffer,
                onChanged: (bool? value) => widget.onChanged!(true),
              ),
              const Text('Yes'),
            ],
          ),
        ),
        InkWell(
          onTap: () => widget.onChanged!(true),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Radio<bool>(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: false,
                groupValue: widget.acceptOffer,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool? value) => widget.onChanged!(true),
              ),
              const Text('No'),
            ],
          ),
        ),
      ],
    );
  }
}
