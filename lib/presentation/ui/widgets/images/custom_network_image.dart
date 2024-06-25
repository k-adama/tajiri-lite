import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class CustomNetworkImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final double radius;
  final Color bgColor;

  const CustomNetworkImage({
    super.key,
    required this.url,
    required this.height,
    required this.width,
    required this.radius,
    this.bgColor = Style.mainBack,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: AppHelpersCommon.checkIsSvg(url)
          ? SvgPicture.network(
              url,
              width: width,
              height: height,
              fit: BoxFit.cover,
              placeholderBuilder: (_) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  color: Style.shimmerBase,
                ),
              ),
            )
          : CachedNetworkImage(
              height: height,
              width: width,
              imageUrl: url,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) {
                return Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Style.shimmerBase,
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: bgColor,
                  ),
                  child: Image.asset(
                    "assets/images/empty_food_url.png",
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}
