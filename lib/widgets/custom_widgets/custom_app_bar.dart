import 'package:flutter/material.dart';
import '../../utilities/app_image.dart';
import '../../utilities/dimensions.dart';
import '../../utilities/styles.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.showBackButton = true, this.onBackPressed, this.onTap});

  final bool showBackButton;
  final Function()? onBackPressed;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.1), spreadRadius: 5, blurRadius: 1)]
      ),

      child: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withOpacity(.125),
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
            ),
              width: 40, child: Image.asset(AppImages.search)),
          centerTitle: false,
          leading: showBackButton ? IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Theme.of(context).primaryColor,
            onPressed: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
          ) :
          SizedBox(
            width: Dimensions.iconSizeLarge,
            child: GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset(AppImages.logo,
                    width: 50),
              ),
            ),
          ),

         actions: [
           Container(
               padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSeven,
                   vertical: Dimensions.paddingSizeExtraSmall),
               decoration: BoxDecoration(
                   color: Theme.of(context).hintColor.withOpacity(.125),
                   borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
               ),
               width: 35, child: Image.asset(AppImages.notification)),

           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 15),
             child: Column(
               children: [
                 Image.asset(AppImages.profile,
                     width: 27),
                  const SizedBox(height: 3,),
                  Text('My Sellout', style: textRegular.copyWith(fontSize: 12),),
               ],
             ),
           ),
         ],


          backgroundColor: Theme.of(context).cardColor,
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(Dimensions.webMaxWidth, Dimensions.appBarHeight);
}