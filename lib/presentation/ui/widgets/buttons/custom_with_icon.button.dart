import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/effects/animation_button.effect.dart';

class CustomButtonWithIcon extends StatelessWidget {
  final String title;
  final bool isLoading;
  final Function()? onPressed;
  final Color background;
  final Color? svgColor;
  final Color textColor;
  final Color? isLoadingColor;
  final double? height;
  final double radius;
  final String imagePath;
  final bool isUnderline;
  final Color underLineColor;
  final bool isGrised;

  const CustomButtonWithIcon({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.height = 40,
    this.imagePath = "",
    this.isUnderline = false,
    this.isGrised = false,
    this.underLineColor = Style.secondaryColor,
    this.background = Style.primaryColor,
    this.textColor = Style.white,
    this.isLoadingColor = Style.white,
    this.radius = 8,
    this.svgColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: SizedBox(
        height: height,
        child: GestureDetector(
          onTap: isGrised ? null : onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius.r),
              color: isGrised == true ? Style.grey100 : background,
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: CircularProgressIndicator(
                          color: isLoadingColor,
                          strokeWidth: 2.r,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: Style.interNormal(
                          size: 15,
                          color: isGrised == true
                              ? Style.selectedItemsText
                              : textColor,
                          underLineColor: underLineColor,
                          isUnderLine: isUnderline,
                          letterSpacing: -14 * 0.01,
                        ).copyWith(fontWeight: FontWeight.w500),
                      ),
                      10.horizontalSpace,
                      SvgPicture.asset(
                        imagePath,
                        width: 20,
                        height: 20,
                        color: svgColor,
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
