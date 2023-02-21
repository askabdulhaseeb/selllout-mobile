import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utilities/app_image.dart';
import '../../utilities/custom_validator.dart';
import '../../utilities/dimensions.dart';
import '../../utilities/styles.dart';
import '../../utilities/utilities.dart';
import '../../widgets/custom_widgets/custom_elevated_button.dart';
import '../../widgets/custom_widgets/custom_file_image_box.dart';
import '../../widgets/custom_widgets/custom_text_field.dart';
import '../../widgets/custom_widgets/custom_textformfield.dart';
import '../../widgets/custom_widgets/show_loading.dart';
import '../../widgets/user/profile_visibility_type.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String routeName = '/register-screen';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (BuildContext context, AuthProvider authPro, _) {
        return Scaffold(
          body: Center(
            child: Form(
              key: authPro.registerKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[

                      const SizedBox(height: 30),
                      SizedBox(width: 200, child: Image.asset(AppImages.nameLogo)),
                      const SizedBox(height: Dimensions.paddingSizeDefault,),

                      const Text('SellOut helps you sell the stuff you want to the people you want.',
                          textAlign: TextAlign.center, style: textRegular),

                      const SizedBox(height: 30),
                      // const SizedBox(height: 30),
                      // CustomFileImageBox(
                      //   file: authPro.profilePhoto,
                      //   onTap: () => authPro.pickProfilePhoto(),
                      // ),
                      // CustomTextFormField(
                      //   controller: authPro.name,
                      //   hint: 'Full Name',
                      //   validator: (String? value) =>
                      //       CustomValidator.lessThen3(value),
                      // ),

                      const SizedBox(height: 30,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.2), spreadRadius: 3, blurRadius: 3)]
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.paddingSizeDefault,),
                          CustomTextField(
                            controller: authPro.name,
                            hintText: 'Full Name',
                            prefixIcon: Icons.perm_identity_rounded,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall,),

                          CustomTextField(
                            controller: authPro.username,
                            hintText: 'Username',
                            prefixIcon: Icons.perm_identity_rounded,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall,),

                          CustomTextField(
                            controller: authPro.username,
                            hintText: 'Date of Birth',
                            prefixIcon: Icons.calendar_month,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall,),


                          Padding(
                            padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault),
                            child: ProfileVisibilityType(
                              isPublic: authPro.isPublicProfile,
                              onChanged: (bool value) =>
                                  authPro.onvisibilityUpdate(value),
                            ),
                          ),

                          CustomTextField(
                            controller: authPro.username,
                            hintText: 'Phone',
                            prefixIcon: Icons.call,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall,),



                          CustomTextField(
                            controller: authPro.username,
                            hintText: 'Email',
                            prefixIcon: Icons.email_outlined,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall,),



                          CustomTextField(
                            controller: authPro.username,
                            hintText: 'Password',
                            isPassword: true,
                            prefixIcon: Icons.lock_outline,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall,),


                          const SizedBox(height: 10),
                          authPro.isRegsiterScreenLoadingn
                              ? const ShowLoading()
                              : CustomElevatedButton(
                            title: 'Register',
                            onTap: () => authPro.onRegister(context),
                          ),
                          const SizedBox(height: 10),

                          Padding(
                            padding: const EdgeInsets.only(bottom : Dimensions.paddingSizeDefault),
                            child: Text.rich(TextSpan(children: [
                              const TextSpan(text: 'By registering you accept Customer', style: textRegular),
                              const TextSpan(text: ' '),
                              TextSpan(text: 'Agreement Conditions', style: textRegular.copyWith(color: Theme.of(context).primaryColor)),
                              const TextSpan(text: ' '),
                              const TextSpan(text: 'and', style: textRegular),
                              const TextSpan(text: ' '),
                              TextSpan(text: 'Privacy Policy.', style: textRegular.copyWith(color: Theme.of(context).primaryColor)),
                            ])),
                          )

                        ],
                      ),),
                      const SizedBox(height: 20),


                      // CustomTextFormField(
                      //   controller: authPro.username,
                      //   hint: 'Username',
                      //   maxLength: Utilities.usernameMaxLength,
                      //   validator: (String? value) =>
                      //       CustomValidator.username(context, value),
                      // ),
                      // CustomTextFormField(
                      //   controller: authPro.bio,
                      //   hint: 'Bio',
                      //   maxLines: 4,
                      //   maxLength: Utilities.bioMaxLength,
                      //   validator: (String? value) => null,
                      // ),
                      // ProfileVisibilityType(
                      //   isPublic: authPro.isPublicProfile,
                      //   onChanged: (bool value) =>
                      //       authPro.onvisibilityUpdate(value),
                      // ),



                      InkWell(
                        onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const LoginScreen())),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                            Text('Already have an account?', style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                            const SizedBox(width: 5,),
                            Text('Login', style: textMedium.copyWith(color: Theme.of(context).primaryColor),),
                          ],),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
