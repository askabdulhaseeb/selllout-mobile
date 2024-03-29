import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../database/auth_methods.dart';
import '../../../../models/app_user.dart';
import '../../../providers/product/add_product_provider.dart';
import '../../../providers/user/user_provider.dart';
import '../../../../utilities/custom_validator.dart';
import '../../../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_widgets/custom_profile_image.dart';
import '../../../../widgets/custom_widgets/custom_textformfield.dart';
import '../../../../widgets/custom_widgets/show_loading.dart';
import '../../../../widgets/product/add_prod_basic_info.dart';
import '../../../../widgets/product/add_product_additional_info.dart';
import '../../../../widgets/product/pick_product_attachments.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AddProductProvider, UserProvider>(builder: (
      BuildContext context,
      AddProductProvider addPro,
      UserProvider userPro,
      _,
    ) {
      final AppUser me = userPro.user(uid: AuthMethods.uid);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: addPro.key,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CustomProfileImage(imageURL: me.imageURL ?? ''),
                    const SizedBox(width: 10),
                    Flexible(
                      child: CustomTextFormField(
                        controller: addPro.title,
                        hint: 'What are you selling...?',
                        validator: (String? value) =>
                            CustomValidator.lessThen3(value),
                      ),
                    ),
                  ],
                ),
                //
                // IMAGES
                //
                GetProductAttachments(
                  file: addPro.files,
                  onTap: () async => await addPro.fetchMedia(),
                ),
                const AddProdBasicInfo(),
                const AddProdAdditionalInfo(),
                addPro.isloading
                    ? const ShowLoading()
                    : CustomElevatedButton(
                        title: 'Post',
                        onTap: () => addPro.onPost(context: context),
                      ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    });
  }
}
