import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GonpaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height; // Add height as a parameter for customization
  final List<Widget>? actions;
  final bool enableBackButton;
  final bool centerTitle;

  const GonpaAppBar({
    super.key,
    required this.title,
    this.height = kToolbarHeight, // Default to AppBar's standard height
    this.actions,
    this.enableBackButton = true,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: enableBackButton
          ? GestureDetector(
              onTap: context.pop,
              child: const Icon(Icons.arrow_back_ios),
            )
          : null,
      title: Text(title),
      actions: actions,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
