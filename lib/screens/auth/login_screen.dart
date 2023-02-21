import 'package:flutter/material.dart';

import '../../utilities/app_image.dart';
import '../../utilities/dimensions.dart';
import '../../utilities/styles.dart';
import '../../widgets/custom_widgets/custom_button.dart';
import '../../widgets/custom_widgets/custom_text_field.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Center(
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              SizedBox(width: 200, child: Image.asset(AppImages.nameLogo)),
             const SizedBox(height: Dimensions.paddingSizeDefault,),
               const Text('SellOut helps you sell the stuff you want to the people you want.',
                   textAlign: TextAlign.center, style: textRegular),
              const SizedBox(height: 30),
              const CustomTextField(
                hintText: 'Email Address',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault,),
              const CustomTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_open_outlined,
                isPassword: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text('Forgot Password?', style: textRegular.copyWith(decoration: TextDecoration.underline),)
                ],),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child: CustomButton(buttonText: 'Login',
                    radius: 10,
                    onPressed: (){}),
              ),

              Row(children: const [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Text('OR'),
                ),
                Expanded(child: Divider(thickness: 1,)),
              ],),

              Row(children: [
                Expanded(
                    child: SocialLoginIcon(
                      icon: AppImages.facebookIcon,
                      title: 'Facebook',
                    )),
                Expanded(
                    child: SocialLoginIcon(
                      icon: AppImages.appleIcon,
                      title: 'Apple',
                    )),
                Expanded(
                    child: SocialLoginIcon(
                      icon: AppImages.googleIcon,
                      title: 'Google',
                    )),
              ],),

              InkWell(
                onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const RegisterScreen())),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                    Text('Don\'t have an account?', style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                   const SizedBox(width: 5,),
                    Text('Register Now', style: textMedium.copyWith(color: Theme.of(context).primaryColor),),
                  ],),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child: CustomButton(buttonText: 'Skip login for now',
                    radius: 10,
                    onPressed: (){
                  Navigator.pop(context);
                    }),
              ),

            ],),
          ),
        ),
      ),
    );
  }
}

class SocialLoginIcon extends StatelessWidget {
  const SocialLoginIcon({ required this.icon, required this.title, Key? key}) : super(key: key);
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Container(height: MediaQuery.of(context).size.width/4,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.2),spreadRadius: 2, blurRadius: 3)]
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 30, child: Image.asset(icon)),
            const SizedBox(height: Dimensions.paddingSizeSmall,),
            Text(title),
          ],
        ),
      ),
    );
  }
}
