import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/auth_methods.dart';
import '../../screens/auth/phone_number_screen.dart';
import '../custom_widgets/custom_elevated_button.dart';
import '../custom_widgets/custom_textformfield.dart';

class DeleteAccountWidget extends StatefulWidget {
  const DeleteAccountWidget({Key? key}) : super(key: key);

  @override
  State<DeleteAccountWidget> createState() => _DeleteAccountWidgetState();
}

class _DeleteAccountWidgetState extends State<DeleteAccountWidget> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: const Icon(
                        CupertinoIcons.delete,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const <Widget>[
                        SizedBox(height: 20),
                        Text(
                          'Delete Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Are you sure you want to delete your account? If you delete your Sellout account, your will permanenlty lose your profile, messages, and photos',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Type "delete account" to confirm',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomTextFormField(
                controller: _controller,
                color: Colors.transparent,
                textAlign: TextAlign.center,
                validator: (String? value) =>
                    value!.toLowerCase() == 'delete account' ||
                            value.toLowerCase() == '"delete account"'
                        ? null
                        : 'Type "delete account" here',
                hint: 'delete account',
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomElevatedButton(
                      title: 'Delete',
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        if (_key.currentState!.validate()) {
                          await AuthMethods().deleteAccount();
                          if (!mounted) return;
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            PhoneNumberScreen.routeName,
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomElevatedButton(
                      title: 'Cancel',
                      bgColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                      textStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                        fontSize: 18,
                      ),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
