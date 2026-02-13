import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/entities/ble_connection_state.dart';

class ReactiveBleDatasource {
  final FlutterReactiveBle ble = FlutterReactiveBle();

  /// デバイススキャン
  Stream<List<BleDevice>> scan() {
    final devices = <String, BleDevice>{};

    return ble.scanForDevices(withServices: []).map((device) {
      devices[device.id] = BleDevice(
        id: device.id,
        name: device.name,
      );
      return devices.values.toList();
    });
  }

  /// デバイス接続
  Stream<BleConnectionState> connect(String deviceId) {
    return ble.connectToDevice(id: deviceId).map((state) {
      switch (state.connectionState) {
        case DeviceConnectionState.connected:
          return BleConnectionState.connected;
        case DeviceConnectionState.connecting:
          return BleConnectionState.connecting;
        default:
          return BleConnectionState.disconnected;
      }
    });
  }

  /// Characteristic 読み取り
  Future<List<int>> read(
      String deviceId, String serviceId, String characteristicId) async {
    final characteristic = QualifiedCharacteristic(
      deviceId: deviceId,
      serviceId: Uuid.parse(serviceId),
      characteristicId: Uuid.parse(characteristicId),
    );
    return ble.readCharacteristic(characteristic);
  }

  /// Characteristic 書き込み
  Future<void> write(
      String deviceId,
      String serviceId,
      String characteristicId,
      List<int> value) async {
    final characteristic = QualifiedCharacteristic(
      deviceId: deviceId,
      serviceId: Uuid.parse(serviceId),
      characteristicId: Uuid.parse(characteristicId),
    );
    await ble.writeCharacteristicWithResponse(characteristic, value: value);
  }
}
