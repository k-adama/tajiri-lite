import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RoundBackButton extends StatelessWidget {
  final String svgPath;
  final Color color;
  const RoundBackButton({super.key, required this.svgPath, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle
      ),
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 20.w,
          height: 20.h,
          decoration: const BoxDecoration(
              shape: BoxShape.circle
          ),
          child: SvgPicture.asset(svgPath),
        ),
      ),
    );
  }
}
