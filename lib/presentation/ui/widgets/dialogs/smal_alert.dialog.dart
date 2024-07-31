import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class SmallDialog extends StatelessWidget {
  final String? title, content;
  final Widget? button;
  final String? asset;

  final Function()? closePressed, redirect;

  const SmallDialog({
    super.key,
    this.title,
    this.content,
    this.redirect,
    this.closePressed,
    this.button,
    this.asset,
  });

  @override
  Widget build(BuildContext context) {
    final isRedirect = redirect != null;
    if (isRedirect) {
      Future.delayed(const Duration(seconds: 2), () {
        redirect?.call();
      });
    }
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              10.verticalSpace,
              if (asset != null)
                Image.asset(
                  asset!,
                  width: 80,
                  height: 80,
                ),
              if (asset != null) 10.verticalSpace,
              Center(
                child: Text(
                  title!,
                  style: Style.interBold(),
                ),
              ),
              10.verticalSpace,
              SizedBox(
                width: 250,
                child: Text(
                  content!,
                  textAlign: TextAlign.center,
                  style: Style.interNormal(size: 12),
                ),
              ),
              if (button != null) 10.verticalSpace,
              if (button != null) button!,
            ],
          ),
        ),
        if (closePressed != null)
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              onPressed: closePressed,
              icon: Icon(Icons.close),
            ),
          ),
      ],
    );
  }
}
