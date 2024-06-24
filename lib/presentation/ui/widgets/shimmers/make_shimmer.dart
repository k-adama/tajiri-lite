import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';


class MakeShimmer extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const MakeShimmer({
    Key? key,
    required this.child,
    this.isLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Style.shimmerBase,
            highlightColor: Style.shimmerHighlight,
            child: child,
          )
        : child;
  }
}
