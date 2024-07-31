import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:tajiri_waitress/app/common/app_helpers.common.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/routes/presentation_screen.route.dart';

class AppMenuModalComponent extends StatelessWidget {
  const AppMenuModalComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppHelpersCommon.getUserInLocalStorage();
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Style.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 6.h,
                width: 180,
                decoration: BoxDecoration(
                  color: Style.grey200,
                  borderRadius: BorderRadius.all(Radius.circular(40.r)),
                ),
              ),
            ),
            20.verticalSpace,
            Center(
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Style.grey50, width: 3)),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          '🧔🏽‍',
                          style: TextStyle(fontSize: 60),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "${user?.lastname ?? ""} ${user?.firstname ?? ''}",
                      style: Style.interBold(color: Style.grey950, size: 15),
                    ),
                  ),
                  Text(
                    user?.role ?? '',
                    style: Style.interNormal(color: Style.grey800, size: 12),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            const Divider(
              thickness: 2,
            ),
            20.verticalSpace,
            buildComponent(
              "Rapport de ventes",
              () {
                Get.toNamed(
                  Routes.SALES_REPORT,
                  preventDuplicates: false,
                );
              },
            ),
            20.verticalSpace,
            buildComponent(
              "Déconnexion",
              () => AppHelpersCommon.logoutApi(),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget buildComponent(
    String text,
    void Function()? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Style.interNormal(size: 15.sp, color: Style.brandBlue950),
          ),
          const Icon(
            Icons.chevron_right,
            color: Style.grey950,
          ),
        ],
      ),
    );
  }
}
