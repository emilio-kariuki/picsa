import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    required this.imageUrl,
    required this.borderRadius,
    required this.height,
    required this.width,
    super.key,
    this.isCirlce = false,
    this.fit = BoxFit.cover,
    this.border,
  });

  final String imageUrl;
  final double height;
  final double width;
  final bool isCirlce;
  final BoxBorder? border;
  final BoxFit? fit;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      imageUrl: imageUrl,
      fit: fit,
      cacheKey: imageUrl,
      fadeInDuration: const Duration(milliseconds: 100),
      errorWidget: (context, url, error) => Container(
        height: height,
        width: width,
        decoration: isCirlce
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: border,
                color: Colors.grey[200],
              )
            : BoxDecoration(
                border: border,
                borderRadius: borderRadius,
                color: Colors.grey[200],
              ),
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[200]!,
        period: const Duration(seconds: 2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: height,
          width: width,
          decoration: isCirlce
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: border,
                  color: Colors.grey[200],
                )
              : BoxDecoration(
                  border: border,
                  borderRadius: borderRadius,
                  color: Colors.grey[200],
                ),
        ),
      ),
      imageBuilder: (context, imageProvider) => AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: height,
        width: width,
        decoration: isCirlce
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: border,
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
                ),
              )
            : BoxDecoration(
                border: border,
                borderRadius: borderRadius,
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
                ),
              ),
      ),
    );
  }
}
