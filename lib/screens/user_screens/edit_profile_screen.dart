import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/user_api.dart';
import '../../functions/picker_functions.dart';
import '../../models/app_user.dart';
import '../../providers/user/user_provider.dart';
import '../../utilities/custom_validator.dart';
import '../../utilities/utilities.dart';
import '../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../widgets/custom_widgets/custom_file_image_box.dart';
import '../../widgets/custom_widgets/custom_network_change_img_box.dart';
import '../../widgets/custom_widgets/custom_title_textformfield.dart';
import '../../widgets/custom_widgets/custom_toast.dart';
import '../../widgets/custom_widgets/show_loading.dart';
import '../../widgets/user/profile_visibility_type.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({required this.user, super.key});
  final AppUser user;
  static const String routeName = '/edit-profile-screen';
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _pickedImage;
  late TextEditingController _name;
  late TextEditingController _username;
  late TextEditingController _bio;
  bool _isloading = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    _name = TextEditingController(text: widget.user.displayName);
    _username = TextEditingController(text: widget.user.username);
    _bio = TextEditingController(text: widget.user.bio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              _pickedImage == null
                  ? CustomNetworkChangeImageBox(
                      url: widget.user.imageURL,
                      title: 'Change Profile Photo',
                      onTap: () => _fetchPhoto(),
                    )
                  : CustomFileImageBox(
                      file: _pickedImage,
                      title: 'Change Profile Photo',
                      onTap: () => _fetchPhoto(),
                    ),
              const Divider(height: 4),
              CustomTitleTextFormField(
                controller: _name,
                title: 'Name',
                readOnly: _isloading,
                maxLength: Utilities.usernameMaxLength,
                validator: (String? value) => CustomValidator.lessThen3(value),
              ),
              const Divider(height: 4),
              CustomTitleTextFormField(
                controller: _username,
                title: 'Username',
                readOnly: _isloading,
                maxLength: Utilities.usernameMaxLength,
                validator: (String? value) => CustomValidator.username(value),
              ),
              const Divider(height: 4),
              CustomTitleTextFormField(
                controller: _bio,
                title: 'Bio',
                readOnly: _isloading,
                maxLines: 5,
                maxLength: Utilities.bioMaxLength,
                validator: (String? value) => CustomValidator.retaunNull(value),
              ),
              const Divider(height: 4),
              ProfileVisibilityType(
                isPublic: widget.user.isPublicProfile,
                onChanged: (bool? value) {
                  if (value == null || _isloading) return;
                  setState(() {
                    widget.user.isPublicProfile = value;
                  });
                },
              ),
              const Divider(height: 4),
              const SizedBox(height: 16),
              _isloading
                  ? const ShowLoading()
                  : CustomElevatedButton(
                      margin: const EdgeInsets.all(16),
                      title: 'Update',
                      onTap: _update,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _update() async {
    if (_key.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      if (_pickedImage != null) {
        final String? tempURL =
            await UserAPI().uploadProfilePhoto(file: _pickedImage!);
        if (tempURL == null) {
          CustomToast.errorToast(message: 'Update Profile Photo shows issues');
        } else if (tempURL != widget.user.imageURL) {
          widget.user.imageURL = tempURL;
        }
      }
      widget.user.displayName = _name.text.trim();
      widget.user.username = _username.text.trim();
      widget.user.bio = _bio.text.trim();
      if (!mounted) {
        setState(() {
          _isloading = false;
        });
        return;
      }
      await Provider.of<UserProvider>(context, listen: false)
          .updateProfile(widget.user);
      if (!mounted) {
        setState(() {
          _isloading = false;
        });
        return;
      }
      Navigator.of(context).pop();
    }
  }

  _fetchPhoto() async {
    final File? temp = await PickerFunctions().image();
    if (temp == null) return;
    setState(() {
      _pickedImage = temp;
    });
  }
}
