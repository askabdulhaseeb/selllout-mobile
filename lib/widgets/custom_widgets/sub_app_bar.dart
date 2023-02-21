import 'package:flutter/material.dart';

import '../../utilities/app_image.dart';
import '../../utilities/dimensions.dart';
import '../../utilities/styles.dart';

class SubAppBar extends StatelessWidget {
   const SubAppBar({Key? key, required this.title,  this.showBack = true,  this.showIcon = false,  this.back = true}) : super(key: key);
  final String title;
  final bool showBack;
  final bool showIcon;
  final bool back;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault, 0,Dimensions.paddingSizeDefault),
      child: Container(decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.3), spreadRadius: 1, blurRadius: 5)]
      ),child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: (){
            if(back){
              Navigator.pop(context);
            }

          },
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
            showBack? const Icon(Icons.keyboard_arrow_left) : const SizedBox(),
            Row(
              children: [
                showIcon?
                    SizedBox(width: 20, child: Image.asset(AppImages.explore)):const SizedBox(),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Text(title, style: textMedium.copyWith(color: showIcon? Theme.of(context).primaryColor : null)),
              ],
            ),
            const SizedBox()
          ],),
        ),
      ),),
    );
  }
}
