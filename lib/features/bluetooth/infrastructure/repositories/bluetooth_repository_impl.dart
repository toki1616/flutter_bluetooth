import '../../domain/entities/ble_device.dart';
import '../../domain/entities/ble_connection_state.dart';
import '../../domain/repositories/bluetooth_repository.dart';
import '../datasources/reactive_ble_datasource.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  final ReactiveBleDatasource datasource;

  BluetoothRepositoryImpl(this.datasource);

  @override
  Stream<List<BleDevice>> scanDevices() {
    return datasource.scan().map((devices) {
      return devices
          .map((d) => BleDevice(id: d.id, name: d.name))
          .toList();
    });
  }

  @override
  Stream<BleConnectionState> connect(String deviceId) {
    return datasource.connect(deviceId).map((state) {
      switch (state) {
        case DeviceConnectionState.connected:
          return BleConnectionState.connected;
        case DeviceConnectionState.connecting:
          return BleConnectionState.connecting;
        default:
          return BleConnectionState.disconnected;
      }
    });
  }

  @override
  Future<List<int>> read(String deviceId, String serviceId, String characteristicId) {
    return datasource.read(deviceId, serviceId, characteristicId);
  }

  @override
  Future<void> write(String deviceId, String serviceId, String characteristicId, List<int> value) {
    return datasource.write(deviceId, serviceId, characteristicId, value);
  }

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) {
    return datasource.discoverServices(deviceId);
  }

  @override
  Stream<List<int>> subscribe(String deviceId, String serviceId, String characteristicId) {
    return datasource.subscribe(deviceId, serviceId, characteristicId);
  }
}
