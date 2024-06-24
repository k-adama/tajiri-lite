import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/shimmers/make_shimmer.dart';

class CommonImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double radius;
  final bool isTopBorderRadius;

  const CommonImage({
    Key? key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 50,
    this.radius = 10,
    this.isTopBorderRadius = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: isTopBorderRadius
          ? BorderRadius.vertical(top: Radius.circular(10.r))
          : BorderRadius.circular(radius.r),
      child: CachedNetworkImage(
        imageUrl: '$imageUrl',
        width: width.r,
        height: height.r,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) {
          return MakeShimmer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: isTopBorderRadius
                    ? BorderRadius.vertical(top: Radius.circular(10.r))
                    : BorderRadius.circular(10.r),
                color: Style.mainBack,
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            height: height.r,
            width: width.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius.r),
              border: Border.all(color: Style.borderColor),
              color: Style.mainBack,
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
