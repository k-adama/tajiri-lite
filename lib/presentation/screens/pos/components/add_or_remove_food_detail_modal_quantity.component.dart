import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/add_or_remove.button.dart';

class AddOrRemoveFoodDteailModalQauntityComponent extends StatelessWidget {
  final String text;
  final VoidCallback add;
  final VoidCallback remove;
  const AddOrRemoveFoodDteailModalQauntityComponent({
    super.key,
    required this.add,
    required this.remove,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
        //color: Style.red,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AddOrRemoveButton(onTap: remove, iconData: Icons.remove),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.r)),
            ),
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              text,
              style: Style.interBold(
                size: 14,
                color: Style.black,
              ),
            ),
          ),
          AddOrRemoveButton(onTap: add, iconData: Icons.add),
        ],
      ),
    );
  }
}
