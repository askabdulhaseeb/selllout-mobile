import 'package:flutter/material.dart';
import '../../models/product/product.dart';
import '../../screens/product_screens/user_products_screen.dart';
import '../../utilities/dimensions.dart';
import '../../utilities/styles.dart';
import '../custom_widgets/custom_network_image.dart';
import '../custom_widgets/network_video_player.dart';

class GridViewOfProducts extends StatelessWidget {
  const GridViewOfProducts({required this.posts, Key? key}) : super(key: key);
  final List<Product> posts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: .75
        ),
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) => InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<UserProductsScreen>(
                builder: (_) =>
                    UserProductsScreen(products: posts, selectedIndex: index),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.09), spreadRadius: 1, blurRadius: 1,offset: Offset(0,1)),],),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: posts[index].prodURL[0].isVideo
                          ? NetworkVideoPlayer(
                              url: posts[index].prodURL[0].url,
                              isMute: true,
                            )
                          : CustomNetworkImage(
                              imageURL: posts[index].prodURL[0].url,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(' ${posts[index].title}', maxLines: 1,style: textRegular,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('\$${posts[index].price}',style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor), maxLines: 1,
                        overflow: TextOverflow.ellipsis,),
                    ),
                    Row(children: [
                      Icon(Icons.place, color: Theme.of(context).hintColor),
                      Text('${posts[index].location}')
                    ],)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
