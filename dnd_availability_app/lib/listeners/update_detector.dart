import 'package:firebase_database/firebase_database.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<bool> hasNewVersion() async {
  try {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = info.version;

    final ref = FirebaseDatabase.instance.ref("appConfig/latestVersion");
    final snap = await ref.get();
    final latest = snap.value?.toString();

    return latest != null && latest != currentVersion;
  } catch (e) {
    return false;
  }
}
