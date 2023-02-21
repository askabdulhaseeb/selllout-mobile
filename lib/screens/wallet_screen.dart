import 'package:flutter/material.dart';

import '../utilities/dimensions.dart';
import '../utilities/styles.dart';
import '../widgets/custom_widgets/custom_app_bar.dart';
import '../widgets/custom_widgets/custom_button.dart';
import '../widgets/custom_widgets/custom_image.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);
  static const String routeName = '/coming-soon-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBackButton: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0),
            child: Container(decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.3), spreadRadius: 1, blurRadius: 5)]
            ),child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: const [
                  Icon(Icons.keyboard_arrow_left),
                  Text('Wallet'),
                  SizedBox()
                ],),
              ),
            ),),
          ),


          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.fontSizeExtraSmall),
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.2), blurRadius: 1, spreadRadius: 3)]
              ),
              child: Column(children: [
                Text('\$500', style: textBold.copyWith(fontSize: 40, color: Theme.of(context).primaryColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text('TOTAL BALANCE', style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                ),
                Text('${'Available Balance'}  ${'\$50.00'}', style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                Text('${'Available Balance'}  ${'\$50.00'}',  style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

              ],),
            ),
          ),
          
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
             child: CustomButton(buttonText: 'Withdraw Money',
          radius: 15,
          onPressed: (){

          }),
           ),

          Padding(
            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0),
            child: Container(decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.3), spreadRadius: 1, blurRadius: 5)]
            ),child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: const [
                  SizedBox(),
                  Text('Complete Transaction'),
                  SizedBox()
                ],),
              ),
            ),),
          ),

          Expanded(child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 13,
                itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.2), blurRadius: 3,spreadRadius: 3)]
                    ),
                    child: Row(children: [
                      CustomImage(image: '',width: 40,height: 40,),

                      const SizedBox(width: Dimensions.paddingSizeDefault,),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                          Text('Sneakers', style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                          Text('26/10/2022', style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                        ],),
                      ),
                      Text('\$323.44', style: textBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),),
                    ],),
                  ),
                );

            }),
          ))



        ],
      )
    );
  }
}
