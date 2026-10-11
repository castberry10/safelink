import 'package:flutter/material.dart';
import 'package:safelink_app/services/localization_service.dart';

Widget redTag({String? text}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.red[400]),
    child: Text(
      text ?? tr('scan_tag_danger'),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}

Widget yellowTag({String? text}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.amber),
    child: Text(
      text ?? tr('scan_tag_caution'),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}

Widget greenTag({String? text}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.green),
    child: Text(
      text ?? tr('scan_tag_safe'),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}

Widget otherTag({String? text}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.grey),
    child: Text(
      text ?? tr('scan_tag_error'),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
