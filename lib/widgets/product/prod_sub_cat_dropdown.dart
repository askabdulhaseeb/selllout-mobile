import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../../models/product/prod_sub_category.dart';
import '../../utilities/utilities.dart';

class ProdSubCatDropdown extends StatelessWidget {
  const ProdSubCatDropdown({
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.borderRadius,
    this.color,
    this.hintText = 'Sub Category',
    this.padding,
    this.margin,
    Key? key,
  }) : super(key: key);
  final List<ProdSubCategory> items;
  final ProdSubCategory? selectedItem;
  final BorderRadiusGeometry? borderRadius;
  final void Function(ProdSubCategory?) onChanged;
  final Color? color;
  final String hintText;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ??
            Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.15),
        borderRadius:
            borderRadius ?? BorderRadius.circular(Utilities.borderRadius / 2),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownSearch<ProdSubCategory>(
        selectedItem: selectedItem,
        items: items,
        itemAsString: (ProdSubCategory? item) => item!.title,
        onChanged: (ProdSubCategory? value) => onChanged(value),
        validator: (ProdSubCategory? value) {
          if (value == null) return 'Sub Category Required';
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
