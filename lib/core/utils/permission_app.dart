import 'package:permission_handler/permission_handler.dart';

class PermissionApp {
  static Future<bool> permissionRequest() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> status = await [
        Permission.audio,
        Permission.videos,
        Permission.photos,
        Permission.storage,
      ].request();

      return status[Permission.storage]?.isGranted ?? false;
    } else {
      return true;
    }
  }
}
