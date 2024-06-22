import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class CheckoutSuccessfullDialog extends StatelessWidget {
  final String? title, content, svgPicture, subtitle;
  final Function()? onPressed, redirect;
  final bool haveButton, isCustomerAdded, isBold, isSubtitle, isPrimaryColor;

  const CheckoutSuccessfullDialog({
    super.key,
    this.title,
    this.content,
    this.redirect,
    this.svgPicture,
    required this.haveButton,
    required this.isCustomerAdded,
    this.onPressed,
    this.isBold = false,
    this.isSubtitle = false,
    this.isPrimaryColor = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isRedirect = redirect != null;
    if (isRedirect) {
      Future.delayed(const Duration(seconds: 2), () {
        redirect?.call();
      });
    }
    return Container(
      width: 355.w,
      height: isRedirect ? 240.h : 311.h,
      decoration: isPrimaryColor
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Style.primaryColor)
          : BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
      child: SingleChildScrollView(
        child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Stack(
              children: [
                isPrimaryColor
                    ? const Positioned(
                        right: -5,
                        child: SizedBox(
                          width: 60,
                          // child: RoundBackButton(
                          //     svgPath: "assets/svgs/carbon_close-filled.svg",
                          //     color: Style.transparent),
                        ),
                      )
                    : const SizedBox(),
                Column(
                  children: [
                    30.verticalSpace,
                    SizedBox(
                      height: isCustomerAdded || isRedirect ? 90.h : 68.h,
                      width: isCustomerAdded || isRedirect ? 90.w : 68.w,
                      child: Center(
                        child: isCustomerAdded || isRedirect
                            ? isPrimaryColor
                                ? Image.asset(
                                    svgPicture!,
                                    fit: BoxFit.cover,
                                  )
                                : SvgPicture.asset(svgPicture!)
                            : Text(
                                title ?? '',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  color: Style.secondaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    if (!isCustomerAdded)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          child: Text(
                            title ?? '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              color: Style.secondaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    6.verticalSpace,
                    Column(
                      children: [
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: Text(
                            content ?? '',
                            textAlign: TextAlign.center,
                            style: isBold
                                ? Style.interBold(size: 18)
                                : GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: Style.dark,
                                    fontWeight: FontWeight.w500,
                                  ),
                          ),
                        ),
                        isSubtitle
                            ? Text(
                                subtitle ?? '',
                                textAlign: TextAlign.center,
                                style: Style.interNormal(size: 14),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
