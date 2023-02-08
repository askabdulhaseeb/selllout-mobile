import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../models/product/product_url.dart';
import '../../providers/app_provider.dart';
import '../custom_widgets/custom_network_image.dart';
import '../custom_widgets/network_video_player.dart';

class ProductURLsSlider extends StatelessWidget {
  const ProductURLsSlider({
    required this.urls,
    this.aspectRatio = 4 / 3,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key);
  final List<ProductURL> urls;
  final double aspectRatio;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: urls
          .map((ProductURL proDetail) => _Attachment(
                url: proDetail,
                totalLength: urls.length,
              ))
          .toList(),
      options: CarouselOptions(
        aspectRatio: 4 / 3,
        viewportFraction: 1,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
    );
  }
}

class _Attachment extends StatelessWidget {
  const _Attachment({required this.url, required this.totalLength, Key? key})
      : super(key: key);
  final ProductURL url;
  final int totalLength;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
            child: url.isVideo
                ? Consumer<AppProvider>(
                    builder: (_, AppProvider appPro, __) => NetworkVideoPlayer(
                      url: url.url,
                      isMute: appPro.isMute,
                    ),
                  )
                : InteractiveViewer(
                    child: CustomNetworkImage(imageURL: url.url),
                  ),
          ),
          if (totalLength > 1 && url.index != 0)
            Positioned(
              top: 0,
              bottom: 0,
              left: 6,
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
            ),
          if (totalLength > 1 && url.index < (totalLength - 1))
            Positioned(
              top: 0,
              bottom: 0,
              right: 6,
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
            ),
          if (totalLength > 1)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 8,
              ),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black45,
              ),
              child: Text(
                '${url.index + 1}/$totalLength',
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
