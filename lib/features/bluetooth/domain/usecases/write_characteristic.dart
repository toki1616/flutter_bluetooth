import '../repositories/bluetooth_repository.dart';

class WriteCharacteristic {
  final BluetoothRepository repository;

  WriteCharacteristic(this.repository);

  Future<void> call({
    required String deviceId,
    required String serviceId,
    required String characteristicId,
    required List<int> value,
  }) {
    return repository.write(deviceId, serviceId, characteristicId, value);
  }
}
