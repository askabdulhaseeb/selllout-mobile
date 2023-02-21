import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../models/product/prod_category.dart';
import '../../utilities/utilities.dart';

class ProdCatDropdown extends StatelessWidget {
  const ProdCatDropdown({
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.borderRadius,
    this.color,
    this.hintText = 'Category',
    this.margin,
    this.padding,
    Key? key,
  }) : super(key: key);
  final List<ProdCategory> items;
  final ProdCategory? selectedItem;
  final BorderRadiusGeometry? borderRadius;
  final void Function(ProdCategory?) onChanged;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final String hintText;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ??
            Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.15),
        borderRadius:
            borderRadius ?? BorderRadius.circular(Utilities.borderRadius),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownSearch<ProdCategory>(
        selectedItem: selectedItem,
        items: items,
        itemAsString: (ProdCategory? item) => item!.title,
        onChanged: (ProdCategory? value) => onChanged(value),
        validator: (ProdCategory? value) {
          if (value == null) return 'Category Required';
          return null;
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: hintText,
            contentPadding: padding ??
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
