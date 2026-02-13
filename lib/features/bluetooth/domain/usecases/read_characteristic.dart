import '../repositories/bluetooth_repository.dart';

class ReadCharacteristic {
  final BluetoothRepository repository;

  ReadCharacteristic(this.repository);

  Future<List<int>> call({
    required String deviceId,
    required String serviceId,
    required String characteristicId,
  }) {
    return repository.read(deviceId, serviceId, characteristicId);
  }
}
