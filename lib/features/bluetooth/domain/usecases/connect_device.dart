import '../entities/ble_connection_state.dart';
import '../repositories/bluetooth_repository.dart';

class ConnectDevice {
  final BluetoothRepository repository;

  ConnectDevice(this.repository);

  Stream<BleConnectionState> call(String deviceId) => repository.connect(deviceId);
}
