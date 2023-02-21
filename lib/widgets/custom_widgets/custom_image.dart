import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


import '../../utilities/app_image.dart';

class CustomImage extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double radius;


   CustomImage({
    super.key,  this.image, this.height, this.width, this.fit = BoxFit.cover,
     this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: image!, height: height, width: width, fit: fit,
        placeholder: (context, url) => Image.asset(AppImages.logo, height: height, width: width, fit: fit),
        errorWidget: (context, url, error) => Image.asset(AppImages.logo, height: height, width: width, fit: fit),
      ),
    );
  }
}
