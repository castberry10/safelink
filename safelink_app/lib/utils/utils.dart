import 'dart:io';
import 'dart:math';

/// Generate a random 6-character alphanumeric string
String generateRandomSixDigitValue() {
  // 1. Get current time in milliseconds
  final currentTime = DateTime.now().millisecondsSinceEpoch.toString();

  // 2. Generate random characters
  final random = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final randomChar =
      List.generate(2, (index) => chars[random.nextInt(chars.length)]).join();

  // 3. Combine timestamp with random characters
  final combined = currentTime + randomChar;

  // 4. Extract the last 6 characters
  return combined.substring(combined.length - 6);
}

/// Check internet connectivity
Future<bool> hasInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

/// URL validation regex
bool isValidUrl(String input) {
  final urlRegex = RegExp(
    r'^(https?:\/\/)?'
    r'((([a-zA-Z0-9\-]+\.)+[a-zA-Z]{1,})|'
    r'localhost|'
    r'(\d{1,3}\.){3}\d{1,3})'
    r'(:\d+)?'
    r'(\/[^\s]*)?$',
    caseSensitive: false,
  );
  return urlRegex.hasMatch(input.trim());
}