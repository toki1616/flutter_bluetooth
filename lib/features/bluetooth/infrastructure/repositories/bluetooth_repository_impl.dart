import '../../domain/entities/ble_device.dart';
import '../../domain/entities/ble_connection_state.dart';
import '../../domain/repositories/bluetooth_repository.dart';
import '../datasources/reactive_ble_datasource.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  final ReactiveBleDatasource datasource;

  BluetoothRepositoryImpl(this.datasource);

  @override
  Stream<List<BleDevice>> scanDevices() => datasource.scan();

  @override
  Stream<BleConnectionState> connect(String deviceId) => datasource.connect(deviceId);

  @override
  Future<List<int>> read(String deviceId, String serviceId, String characteristicId) =>
      datasource.read(deviceId, serviceId, characteristicId);

  @override
  Future<void> write(String deviceId, String serviceId, String characteristicId, List<int> value) =>
      datasource.write(deviceId, serviceId, characteristicId, value);
}
