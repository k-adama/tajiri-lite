import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class LoadingUi extends StatelessWidget {
  final Color bgColor;
  const LoadingUi({super.key, this.bgColor = Style.textGrey});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isAndroid
          ? const CircularProgressIndicator()
          : CupertinoActivityIndicator(
              color: bgColor,
              radius: 12,
            ),
    );
  }
}
