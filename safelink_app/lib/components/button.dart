import 'package:flutter/material.dart';
import 'package:safelink_app/const/colors.dart';

Widget customButton(
    {required String text,
    required VoidCallback onPressed,
    Color backgroundColor = AppColors.primaryColor,
    Color textColor = Colors.white,
    double borderRadius = 12.0,
    double padding = 10,
    double fontSize = 20}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.all(padding),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: textColor, fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

TextButton whiteButton(
    {void Function()? onPressed,
    Color colors = AppColors.black,
    required String text}) {
  return TextButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white.withValues(alpha: 0),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 16, color: colors),
    ),
  );
}

TextButton whiteArrowButton(
    {void Function()? onPressed,
    String? assetPath,
    String? assetName,
    required String text}) {
  return TextButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white.withValues(alpha: 0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryColor),
      ],
    ),
  );
}

TextButton whiteLogoButton(
    {void Function()? onPress,
    String? assetPath,
    String? assetName,
    required String text,
    required bool isLogo}) {
  return TextButton(
    onPressed: onPress,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white.withValues(alpha: 0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        isLogo
            ? Row(
                children: [
                  Text(
                    assetName!,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  Image.asset(
                    assetPath!,
                    width: 24,
                    height: 24,
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ],
    ),
  );
}