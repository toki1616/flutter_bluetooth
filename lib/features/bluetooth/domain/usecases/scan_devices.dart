import '../entities/ble_device.dart';
import '../repositories/bluetooth_repository.dart';

class ScanDevices {
  final BluetoothRepository repository;

  ScanDevices(this.repository);

  Stream<List<BleDevice>> call() => repository.scanDevices();
}

