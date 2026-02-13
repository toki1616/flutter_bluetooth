import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../entities/ble_device.dart';
import '../entities/ble_connection_state.dart';

abstract class BluetoothRepository {
  Stream<List<BleDevice>> scanDevices();
  Stream<BleConnectionState> connect(String deviceId);

  Future<List<int>> read(String deviceId, String serviceId, String characteristicId);
  Future<void> write(String deviceId, String serviceId, String characteristicId, List<int> value);

  Future<List<DiscoveredService>> discoverServices(String deviceId);
  Stream<List<int>> subscribe(String deviceId, String serviceId, String characteristicId);
}

