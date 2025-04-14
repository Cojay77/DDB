// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:flutter/foundation.dart';

bool isAppInstalled() {
  if (!kIsWeb || !_isStandalone()) return false;

  try {
    return js.context.callMethod('isInStandaloneMode') as bool;
  } catch (_) {
    return false;
  }
}

bool _isStandalone() {
  try {
    return js.context.callMethod('isInStandaloneMode') as bool;
  } catch (_) {
    return false;
  }
}
