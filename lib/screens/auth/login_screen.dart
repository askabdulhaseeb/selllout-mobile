import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../database/auth_methods.dart';
import '../../utilities/app_image.dart';
import '../../utilities/custom_services.dart';
import '../../utilities/custom_validator.dart';
import '../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../widgets/custom_widgets/custom_textformfield.dart';
import '../../widgets/custom_widgets/password_textformfield.dart';
import '../../widgets/custom_widgets/show_loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/LoginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  height: 140,
                  width: 140,
                  child: Image.asset(AppImages.logo),
                ),
              ),
              const SizedBox(height: 40),
              _titleText('EMAIL ADDRESS'),
              CustomTextFormField(
                controller: _email,
                hint: 'test@test.com',
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) => CustomValidator.email(value),
              ),
              const SizedBox(height: 6),
              _titleText('PASSWORD'),
              PasswordTextFormField(controller: _password),
              const SizedBox(height: 16),
              isLoading
                  ? const ShowLoading()
                  : CustomElevatedButton(
                      title: 'Log In',
                      onTap: () => _submitForm(),
                    ),
              _forgetPassword(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_key.currentState!.validate()) {
      CustomService.dismissKeyboard();
      setState(() {
        isLoading = true;
      });
      final User? user = await AuthMethods().loginWithEmailAndPassword(
        _email.text,
        _password.text,
      );
      if (!mounted) return;
      setState(() {
        isLoading = true;
      });
      if (user != null) {
        // Provider.of<AppProvider>(context, listen: false).onTabTapped(0);
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //     MainScreen.rotueName, (Route<dynamic> route) => false);
      }
    }
  }

  TextButton _forgetPassword() {
    return TextButton(
      onPressed: () {
        if (!isLoading) {
          // Navigator.of(context).pushNamed(ForgetPasswordScreen.routeName);
        }
      },
      child: Text(
        'Forget Password?',
        style: TextStyle(
          color: isLoading ? Colors.grey : Colors.black,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Text _titleText(String title) {
    return Text(
      ' $title',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
