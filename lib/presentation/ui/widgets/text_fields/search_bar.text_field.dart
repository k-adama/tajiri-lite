import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tajiri_waitress/app/config/theme/style.theme.dart';

class SearchBarTextField extends StatefulWidget {
  final String hintText;
  final Color? color;
  final Function(String text) onSearch;
  final FocusNode? focusNode;
  final TextEditingController searchController;

  const SearchBarTextField({
    super.key,
    required this.hintText,
    required this.onSearch,
    this.focusNode,
    this.color = Style.white,
    required this.searchController,
  });

  @override
  State<SearchBarTextField> createState() => _SearchBarTextFieldState();
}

class _SearchBarTextFieldState extends State<SearchBarTextField> {
  bool isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(() {
        if (mounted) {
          setState(() {
            isSearchFocused = widget.focusNode!.hasFocus;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 48.0,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Style.grey50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Style.grey100)),
                child: TextField(
                  controller: widget.searchController,
                  onChanged: (text) {
                    widget.onSearch(text);
                  },
                  focusNode: widget.focusNode,
                  enableSuggestions: false,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: isSearchFocused ||
                            widget.searchController.text.isNotEmpty
                        ? ""
                        : widget.hintText,
                    suffixIcon: widget.searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              widget.searchController.clear();
                              widget.onSearch("");
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Style.dark,
                              size: 20,
                            ),
                          )
                        : null,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.search,
                        color: Style.titleDark,
                        size: 25,
                      ),
                    ),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: Style.secondaryColor,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
