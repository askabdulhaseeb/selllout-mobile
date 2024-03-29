import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/product/prod_category.dart';
import '../../models/product/prod_sub_category.dart';

class ProdCatProvider extends ChangeNotifier {
  ProdCategory? _selectedCat;
  List<ProdSubCategory> _subCategory = <ProdSubCategory>[];
  ProdSubCategory? _selectedSubCat;
  final List<ProdCategory> _cat = <ProdCategory>[
    ProdCategory(
      catID: 'trousers',
      title: 'Trousers',
      subCategories: <ProdSubCategory>[
        ProdSubCategory(subCatID: 'trousers1', title: 'Trousers1'),
        ProdSubCategory(subCatID: 'trousers2', title: 'Trousers2'),
        ProdSubCategory(subCatID: 'trousers3', title: 'Trousers3'),
      ],
    ),
    ProdCategory(
      catID: 'accessories',
      title: 'Accessories',
      subCategories: <ProdSubCategory>[
        ProdSubCategory(subCatID: 'accessories1', title: 'Accessories1'),
        ProdSubCategory(subCatID: 'accessories2', title: 'Accessories2'),
        ProdSubCategory(subCatID: 'accessories3', title: 'Accessories3'),
      ],
    ),
    ProdCategory(
      catID: 'hats',
      title: 'Hats',
      subCategories: <ProdSubCategory>[
        ProdSubCategory(subCatID: 'hats1', title: 'Hats1'),
        ProdSubCategory(subCatID: 'hats2', title: 'Hats2'),
        ProdSubCategory(subCatID: 'hats3', title: 'Hats3'),
      ],
    ),
    ProdCategory(
      catID: 'jewellery',
      title: 'Jewellery',
      subCategories: <ProdSubCategory>[
        ProdSubCategory(subCatID: 'jewellery2', title: 'Jewellery2'),
        ProdSubCategory(subCatID: 'jewellery3', title: 'Jewellery3'),
        ProdSubCategory(subCatID: 'jewellery4', title: 'Jewellery4'),
        ProdSubCategory(subCatID: 'jewellery5', title: 'Jewellery5'),
      ],
    ),
  ];

  List<ProdCategory> get category => <ProdCategory>[..._cat];
  List<ProdSubCategory> get subCategory => <ProdSubCategory>[..._subCategory];
  ProdCategory? get selectedCategroy => _selectedCat;
  ProdSubCategory? get selectedSubCategory => _selectedSubCat;

  void updateCatSelection(ProdCategory updatedCategroy) {
    _selectedCat = updatedCategroy;
    _subCategory = updatedCategroy.subCategories;
    _selectedSubCat = null;
    notifyListeners();
  }

  void updateSubCategorySection(ProdSubCategory update) {
    _selectedSubCat = update;
    notifyListeners();
  }
}
