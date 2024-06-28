import 'package:flutter/material.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';
import 'package:tajiri_waitress/presentation/controllers/pos/pos.controller.dart';
import 'package:tajiri_waitress/presentation/ui/widgets/text_fields/search_bar.text_field.dart';

class PosSearchComponent extends StatefulWidget {
  final PosController posController;
  const PosSearchComponent({super.key, required this.posController});

  @override
  State<PosSearchComponent> createState() => _PosSearchState();
}

class _PosSearchState extends State<PosSearchComponent> {
  final TextEditingController searchController = TextEditingController();
  bool isSearchFocused = false;
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      setState(() {
        isSearchFocused = searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Style.white,
      ),
      child: SearchBarTextField(
        searchController: searchController,
        hintText: "Rechercher un plat, une boisson ...",
        focusNode: searchFocusNode,
        onSearch: (text) {},
      ),
    );
  }
}
