import 'package:flutter/material.dart';

/// PXButton (Paisamex Button)
/// Un botón reutilizable con variantes `filled`, `outlined` y `text`.
/// * Soporta icono o imagen a la izquierda.
/// * Maneja estado de carga.
/// * Puede expandirse al ancho completo si se envuelve con `Expanded` o usando `expand: true`.
/// * Asegura que el texto no se desborde (usa ellipsis).
class PXButton extends StatelessWidget {
  const PXButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PXButtonVariant.filled,
    this.expand = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
    this.image,
  });

  // ────────────────────────────────────────────────────────────────────────────
  //  Public API
  // ────────────────────────────────────────────────────────────────────────────
  final String label;
  final VoidCallback? onPressed;
  final PXButtonVariant variant;
  final bool expand;
  final bool isLoading;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final IconData? icon;
  final Widget? image;

  // ────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Colores efectivos dependiendo de la variante o sobrescritura manual
    final Color effectiveBg =
        backgroundColor ??
        switch (variant) {
          PXButtonVariant.filled =>
            isDisabled ? colorScheme.surfaceContainerHighest : colorScheme.primary,
          PXButtonVariant.outlined || PXButtonVariant.text =>
            isDisabled ? colorScheme.surfaceContainerHighest : Colors.transparent,
        };

    final Color effectiveText =
        textColor ??
        switch (variant) {
          _ when isDisabled => colorScheme.onSurface.withValues(alpha: 0.38),
          PXButtonVariant.filled => colorScheme.onPrimary,
          PXButtonVariant.outlined || PXButtonVariant.text => colorScheme.primary,
        };

    final Color effectiveBorder =
        isDisabled
            ? colorScheme.outline
            : borderColor ??
                switch (variant) {
                  PXButtonVariant.outlined => colorScheme.primary,
                  _ when isDisabled => colorScheme.outline,
                  _ => Colors.transparent,
                };

    // Contenido interno (loading o label + ícono)
    final Widget content =
        isLoading
            // ? SizedBox(
            //   width: 24,
            //   height: 24,
            //   child: CircularProgressIndicator(
            //     strokeWidth: 2,
            //     color:
            //         variant == PXButtonVariant.filled
            //             ? AppColors.white
            //             : AppColors.primary,
            //   ),
            // )
            ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                      variant == PXButtonVariant.filled
                          ? colorScheme.onPrimary
                          : colorScheme.primary,
                ),
              ],
            )
            : Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) Icon(icon, size: 20, color: effectiveText),
                if (image != null) image!,
                if (icon != null || image != null) const SizedBox(width: 8),
                // Flexible evita overflow y muestra … si no cabe
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );

    // Estilo común a toda variante
    final ButtonStyle baseStyle = ButtonStyle(
      textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 16)),
      foregroundColor: WidgetStateProperty.all(effectiveText),
      backgroundColor: WidgetStateProperty.all(effectiveBg),
      minimumSize: WidgetStateProperty.all(const Size(0, 48)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      side: WidgetStateProperty.all(BorderSide(color: effectiveBorder)),
    );

    // Selección del widget específico
    late final Widget button;
    switch (variant) {
      case PXButtonVariant.filled:
        button = FilledButton(
          onPressed: isLoading || isDisabled ? null : onPressed,
          style: baseStyle,
          child: content,
        );
        break;
      case PXButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading || isDisabled ? null : onPressed,
          style: baseStyle,
          child: content,
        );
        break;
      case PXButtonVariant.text:
        button = TextButton(
          onPressed: isLoading || isDisabled ? null : onPressed,
          style: baseStyle,
          child: content,
        );
        break;
    }

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

// Variantes visuales admitidas por [PXButton].
enum PXButtonVariant { filled, outlined, text }
