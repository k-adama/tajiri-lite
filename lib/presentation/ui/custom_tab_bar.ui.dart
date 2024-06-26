import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class CustomTabBarUi extends StatelessWidget {
  final bool isScrollable;
  final TabController tabController;
  final List<Tab> tabs;
  final bool isIndicator;
  final Color backgroundColor;
  final Color labelColor;
  final Color indicatorColorStyle;

  const CustomTabBarUi(
      {super.key,
      required this.tabController,
      required this.tabs,
      this.backgroundColor = Style.white,
      this.labelColor = Style.black,
      this.indicatorColorStyle = Style.black,
      this.isIndicator = true,
      this.isScrollable = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      padding: EdgeInsets.all(5),
      child: TabBar(
        isScrollable: isScrollable,
        controller: tabController,
        indicatorColor: indicatorColorStyle,
        indicatorSize: isIndicator ? TabBarIndicatorSize.tab : null, //
        dividerHeight: 0,
        labelPadding: isIndicator ? null : EdgeInsets.only(right: 40),
        padding: isIndicator ? null : EdgeInsets.only(left: 10),
        indicator: isIndicator
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color: Style.brandBlue950)
            : null,
        labelColor: Style.brandBlue50,
        unselectedLabelColor: Style.brandBlue950,
        unselectedLabelStyle: Style.interBold(
          size: 14.sp,
        ),
        labelStyle: Style.interNormal(
          size: 14.sp,
        ),
        tabs: tabs.map((Tab tab) {
          return Container(
            child: Row(
              children: [
                Text(
                  tab.text ?? "",
                  //style:  Style.interNormal(color: Style.red),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
