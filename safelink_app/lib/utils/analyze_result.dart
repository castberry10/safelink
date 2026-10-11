import 'package:safelink_app/services/localization_service.dart';

Map<String, dynamic> analyzeResult({
  required int llmScore,
  required int google,
  required String llmText,
}) {
  int state = 1;
  String text = "";

  if (llmScore == 3) {
    state = 3;
    text = llmText;
  } else if (llmScore == 2) {
    state = 2;
    text = llmText;
  } else if (llmScore == 1) {
    state = 1;
    text = llmText;
  } else {
    state = 4;
    text = llmText;
  }

  final isReported = google == 1;
  if (isReported) {
    final dangerMsg = tr('scan_reported_danger');
    state = 3;
    text = text.isEmpty ? dangerMsg : text;
  }

  return {
    'state': state, // 1: safe, 2: caution, 3: danger
    'text': text,
  };
}