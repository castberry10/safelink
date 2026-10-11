import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safelink_app/screens/setting_screen.dart';

AppBar safeLinkAppBar(BuildContext context) {
  return AppBar(
    leading: Container(
      width: 20,
      margin: const EdgeInsets.only(left: 32),
      child: SvgPicture.asset(
        'assets/logo.svg',
        height: 20,
      ),
    ),
    titleSpacing: 8.0,
    title: const Text('SafeLink'),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingScreen()),
          );
        },
        icon: const Icon(Icons.settings),
      ),
    ],


  );
} 