import 'package:flutter/material.dart';

import '../../../utilities/app_image.dart';
import '../../../utilities/styles.dart';
import '../../../widgets/custom_widgets/custom_app_bar.dart';
import '../../../widgets/custom_widgets/custom_button.dart';
import '../../../widgets/custom_widgets/custom_image.dart';
import '../../../widgets/custom_widgets/custom_search_field.dart';
import '../../live_screens/bid_page/bid_page.dart';

class LivePage extends StatelessWidget {
  const LivePage({Key? key}) : super(key: key);
  static const String routeName = '/live-page';



  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return  Scaffold(
      appBar: const CustomAppBar(showBackButton: false,),
      body: Column(children: [

        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(width: 150,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.1), blurRadius: 2, spreadRadius: 1)]
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                SizedBox(
                    width: 25, child: Image.asset(AppImages.liveBid)),
                const SizedBox(width: 10,),
                Text('Live Bid', style: textSemiBold.copyWith(color: Theme.of(context).primaryColor, fontSize: 15),)
              ],),
            ),
          ),
        ),


        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.2), spreadRadius: 2, blurRadius: 5)]
              ),
              child: Column(children: [
                SizedBox(width: MediaQuery.of(context).size.width/2,
                    child: CustomButton(buttonText: 'Go Live',
                        radius: 10,
                        onPressed: (){})),
                const SizedBox(height: 15,),
                CustomSearchField(
                    controller: searchController,
                    hint: 'Search Here',
                    prefix: Icons.search,
                    iconPressed: (){}),
                SizedBox(height: 10,),

                Expanded(child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                    itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 2, right: 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.1), blurRadius: 2, spreadRadius: 1)]
                        ),
                      child: Row(children: [
                        SizedBox(width: 40,height: 40,child: CustomImage(image: '',width: 40,height: 40,),),
                        const SizedBox(width: 10),
                        const Expanded(child: Text('Philip Pitt', style: textRegular,)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                SizedBox(
                                    width: 15, child: Image.asset(AppImages.liveBid, color: Colors.white,)),
                                const SizedBox(width: 10,),
                                Text('Live', style: textSemiBold.copyWith(color: Theme.of(context).cardColor, fontSize: 12,),)
                              ],),
                            ),
                          ),
                        ),

                      ],),

                    ),
                  );
                }))

              ],),),
          ),
        )

      ],)
    );
  }
}
