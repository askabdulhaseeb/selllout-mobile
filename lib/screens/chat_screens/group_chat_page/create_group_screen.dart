import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../../../../widgets/custom_widgets/custom_textformfield.dart';
import '../../../../../widgets/custom_widgets/show_loading.dart';
import '../../../providers/chat/group_chat_provider.dart';
import '../../../utilities/custom_validator.dart';
import '../../../utilities/utilities.dart';
import '../../../widgets/custom_widgets/custom_file_image_box.dart';
import '../../../widgets/custom_widgets/title_text.dart';

class CreateChatGroupScreen extends StatefulWidget {
  const CreateChatGroupScreen({Key? key}) : super(key: key);
  static const String routeName = '/CreateChatGroupScreen';
  @override
  State<CreateChatGroupScreen> createState() => _CreateChatGroupScreenState();
}

class _CreateChatGroupScreenState extends State<CreateChatGroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Create Group',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
      ),
      body: Consumer<GroupChatProvider>(
          builder: (BuildContext context, GroupChatProvider groupPro, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: groupPro.key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomFileImageBox(
                    file: groupPro.imageFile,
                    onTap: () => groupPro.onImagePick(),
                  ),
                  const CustomTitleText(title: 'Group Name'),
                  CustomTextFormField(
                    controller: groupPro.name,
                    readOnly: groupPro.isLoading,
                    hint: 'A short name of your group',
                    validator: (String? value) =>
                        CustomValidator.lessThen2(value),
                  ),
                  const SizedBox(height: 6),
                  const CustomTitleText(title: 'Group Description'),
                  CustomTextFormField(
                    controller: groupPro.description,
                    readOnly: groupPro.isLoading,
                    hint: 'Add group description',
                    maxLines: 4,
                    maxLength: Utilities.groupDescriptionMaxLength,
                    validator: (String? value) =>
                        CustomValidator.retaunNull(value),
                  ),
                  const SizedBox(height: 10),
                  groupPro.isLoading
                      ? const ShowLoading()
                      : CustomElevatedButton(
                          title: 'Create Group',
                          onTap: () => groupPro.onCreateGroup(),
                        ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
