import 'package:flutter/material.dart';
import 'package:safelink_app/const/colors.dart';
import 'package:safelink_app/services/localization_service.dart';

Future<void> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  String? confirmText,
  String? cancelText,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext ctx) {
      return AlertDialog(
        backgroundColor: ctx.surfaceColor,
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: ctx.textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: TextStyle(color: ctx.textColor),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          ctx.textSecondaryColor),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onCancel?.call();
                    },
                    child: Text(
                      cancelText ?? tr('common_cancel'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          AppColors.primaryColor),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onConfirm();
                    },
                    child: Text(
                      confirmText ?? tr('common_delete'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}