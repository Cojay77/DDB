// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

bool isIOSBrowser() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  return userAgent.contains('iphone') || userAgent.contains('ipad');
}
