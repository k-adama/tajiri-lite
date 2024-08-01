import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/effects/animation_button.effect.dart';

class IconWithTextButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final bool isSecondary;
  final bool isGrised;
  final Color bgColor;
  final Color titleColor;
  final IconData? icon;
  final Function()? onPressed;

  const IconWithTextButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.isGrised = false,
    this.bgColor = Style.brandColor500,
    this.titleColor = Style.black,
    this.isSecondary = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: Material(
        borderRadius: BorderRadius.circular(8.r),
        color: isGrised == true
            ? Style.grey100
            : isSecondary
                ? Colors.transparent
                : bgColor,
        child: InkWell(
          onTap: isGrised
              ? null
              : isLoading
                  ? () {
                      print("========Chargement en cours========");
                      AppHelpersCommon.showCheckTopSnackBarInfo(
                        context,
                        displayDuration: const Duration(seconds: 1),
                        "Veuillez patienter Chargement en cours...",
                      );
                    }
                  : onPressed,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            height: 56.r,
            padding: EdgeInsets.symmetric(horizontal: 12.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isGrised == true
                    ? Style.selectedItemsText
                    : isSecondary
                        ? bgColor
                        : bgColor == Style.transparent
                            ? Style.selectedItemsText
                            : Style.transparent,
              ),
            ),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    height: 24.r,
                    width: 24.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.r,
                      color: Style.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          icon,
                          color: isGrised == true
                              ? Style.selectedItemsText
                              : titleColor,
                        ),
                      ),
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: isGrised == true
                              ? Style.selectedItemsText
                              : titleColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
