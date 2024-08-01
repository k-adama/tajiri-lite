import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/add_or_remove.button.dart';

class AddOrRemoveItemComponent extends StatelessWidget {
  final VoidCallback add;
  final VoidCallback remove;
  const AddOrRemoveItemComponent({
    super.key,
    required this.add,
    required this.remove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
        color: Style.white,
        border: Border.all(color: Style.grey100, width: 0.7.w),
      ),
      child: Row(
        children: [
          AddOrRemoveButton(
            onTap: remove,
            iconData: Icons.remove,
            sizeButton: 25,
            iconsize: 15,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 3.0, bottom: 3, left: 5, right: 5),
            child: Container(
              width: 0.7,
              height: 30,
              decoration: const BoxDecoration(color: Style.brandColor50),
            ),
          ),
          AddOrRemoveButton(
            onTap: add,
            iconData: Icons.add,
            sizeButton: 25,
            iconsize: 15,
          ),
        ],
      ),
    );
  }
}
