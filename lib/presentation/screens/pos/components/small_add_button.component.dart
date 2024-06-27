import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/buttons/effects/animation_button.effect.dart';

class SmallAddButtonComponent extends StatelessWidget {
  final VoidCallback onTap;
  final double width;
  final double height;
  final Color color;

  const SmallAddButtonComponent({
    super.key,
    required this.onTap,
    this.width = 32,
    this.height = 32,
    this.color = Style.brandColor500,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimationButtonEffect(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
