import 'package:permission_handler/permission_handler.dart';

class RequestPermission {
  Future<bool> execute() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> status = await [
        Permission.audio,
        Permission.videos,
        Permission.photos,
        Permission.manageExternalStorage,
      ].request();

      return (status[Permission.audio]!.isGranted &&
          status[Permission.videos]!.isGranted &&
          status[Permission.photos]!.isGranted &&
          status[Permission.manageExternalStorage]!.isGranted);
    } else {
      return status.isDenied;
    }
  }
}
