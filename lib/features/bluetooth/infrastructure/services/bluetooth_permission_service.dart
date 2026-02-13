import 'package:permission_handler/permission_handler.dart';

class BluetoothPermissionService {
  Future<bool> requestPermissions() async {
    final scan = await Permission.bluetoothScan.request();
    final connect = await Permission.bluetoothConnect.request();
    final location = await Permission.locationWhenInUse.request();

    return scan.isGranted && connect.isGranted && location.isGranted;
  }
}
