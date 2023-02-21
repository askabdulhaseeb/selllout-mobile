import 'package:flutter/material.dart';

import '../../utilities/app_image.dart';
import '../../utilities/dimensions.dart';
import '../../utilities/styles.dart';


class CustomSearchField extends StatefulWidget {
  const CustomSearchField({
    required this.controller,
    required this.hint,
    required this.prefix,
    required this.iconPressed,
    super.key,
    this.onSubmit,
    this.onChanged,
    this.filterAction,
    this.isFilter = false,
  });
  final TextEditingController controller;
  final String hint;
  final IconData prefix;
  final Function()? iconPressed;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final Function()? filterAction;
  final bool isFilter;

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 45,
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: widget.hint,

              hintStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).disabledColor),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 0,color: Colors.transparent),
              ),
              filled: true, fillColor: Theme.of(context).hintColor.withOpacity(.07),
              isDense: true,
              focusedBorder:OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: .30),
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: IconButton(
                onPressed: widget.iconPressed,
                icon: Icon(widget.prefix,size: 35, color: Theme.of(context).hintColor.withOpacity(.35)),
              ),
            ),
            onSubmitted: widget.onSubmit,
            onChanged: widget.onChanged,
          ),
        ),


       widget.isFilter ? Padding(
          padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Container(width: 45,height: 45,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.13), blurRadius: 5, spreadRadius: 3)]
            ),
            child: GestureDetector(

              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(AppImages.filterIcon, color: Theme.of(context).textTheme.bodyLarge!.color,),
              ),
            ),
          ),
        ) : const SizedBox(),
      ],),
    );
  }
}
