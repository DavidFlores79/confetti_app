// lib/shared/widgets/px_back_app_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PxBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? backLabel;
  final VoidCallback? onBackPressed;
  final double height;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const PxBackAppBar({
    super.key,
    this.backLabel = 'Regresar',
    this.onBackPressed,
    this.height = 65, // altura personalizada
    this.actions,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      // Asegura que AppBar respete la altura
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      toolbarHeight: height,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: BackButton(
            color: theme.colorScheme.onSurface,
            onPressed: onBackPressed ?? () => context.pop(),
          ),
        ),
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          backLabel!,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: theme.dividerTheme.color),
      ),
      actions: actions,
    );
  }
}
