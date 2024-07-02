import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class EmptyProductComponent extends StatelessWidget {
  const EmptyProductComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Aucun produit trouvé",
            style: Style.interBold(size: 20),
          ),
        ],
      ),
    );
  }
}
