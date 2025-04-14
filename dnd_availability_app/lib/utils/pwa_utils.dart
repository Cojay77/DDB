// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

bool isStandalone() {
  try {
    return js.context.callMethod('isInStandaloneMode') as bool;
  } catch (_) {
    return false;
  }
}
