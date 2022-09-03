import 'package:flutter/material.dart';
import '../../models/product/product.dart';
import '../../screens/product_screens/user_products_screen.dart';
import '../custom_widgets/custom_network_image.dart';
import '../custom_widgets/network_video_player.dart';

class GridViewOfProducts extends StatelessWidget {
  const GridViewOfProducts({required this.posts, Key? key}) : super(key: key);
  final List<Product> posts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      primary: true,
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) => InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<UserProductsScreen>(
              builder: (_) =>
                  UserProductsScreen(products: posts, selectedIndex: index),
            ),
          );
        },
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(
                tag: posts[index].pid,
                child: AspectRatio(
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
              ),
              SizedBox(
                height: 20,
                child: Text(
                  ' ${posts[index].price} - ${posts[index].title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
