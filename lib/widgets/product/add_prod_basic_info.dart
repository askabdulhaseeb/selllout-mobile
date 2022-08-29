import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product/prod_category.dart';
import '../../models/product/prod_sub_category.dart';
import '../../providers/product/app_product_provider.dart';
import '../../providers/product/product_category_provider.dart';
import '../../utilities/custom_validator.dart';
import '../../utilities/utilities.dart';
import '../custom_widgets/custom_textformfield.dart';
import '../custom_widgets/text_between_lines.dart';
import '../custom_widgets/title_text.dart';
import 'prod_cat_dropdown.dart';
import 'prod_sub_cat_dropdown.dart';

class AddProdBasicInfo extends StatelessWidget {
  const AddProdBasicInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AddProductProvider, ProdCatProvider>(builder: (
      BuildContext context,
      AddProductProvider addPro,
      ProdCatProvider catPro,
      _,
    ) {
      final List<ProdCategory> categories = catPro.category;
      final List<ProdSubCategory> subCategories = catPro.subCategory;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8),
          const TextBetweenLines(title: 'Basic information'),
          CustomTitleText(title: 'Description'.toUpperCase()),
          CustomTextFormField(
            controller: addPro.description,
            minLines: 1,
            maxLines: 5,
            hint: 'Write something about product',
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            validator: (String? p0) => null,
          ),
          CustomTitleText(title: 'Category'.toUpperCase()),
          ProdCatDropdown(
            items: categories,
            borderRadius: BorderRadius.circular(Utilities.borderRadius / 2),
            hintText: 'Select...',
            selectedItem: catPro.selectedCategroy,
            onChanged: (ProdCategory? update) {
              catPro.updateCatSelection(update!);
            },
          ),
          CustomTitleText(title: 'Sub Category'.toUpperCase()),
          ProdSubCatDropdown(
            items: subCategories,
            hintText: 'Select...',
            selectedItem: catPro.selectedSubCategory,
            onChanged: (ProdSubCategory? update) {
              catPro.updateSubCategorySection(update!);
            },
          ),
          CustomTitleText(title: 'Price'.toUpperCase()),
          CustomTextFormField(
            controller: addPro.price,
            hint: 'Select Price',
            validator: (String? value) => CustomValidator.isEmpty(value),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
          ),
          CustomTitleText(title: 'Quantity'.toUpperCase()),
          const _QuantityTextFormField(),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}

class _QuantityTextFormField extends StatelessWidget {
  const _QuantityTextFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProductProvider>(
      builder: (BuildContext context, AddProductProvider addPro, _) {
        return Row(
          children: <Widget>[
            IconButton(
              onPressed: () => addPro.onQuantityUpdate(increase: false),
              splashRadius: Utilities.borderRadius,
              icon: Icon(
                Icons.remove_circle_outline,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomTextFormField(
                controller: addPro.quantity,
                showSuffixIcon: false,
                validator: (String? value) => CustomValidator.isEmpty(value),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () => addPro.onQuantityUpdate(increase: true),
              splashRadius: Utilities.borderRadius,
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
