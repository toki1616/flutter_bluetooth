import '../repositories/bluetooth_repository.dart';

class ReadParams {
  final String deviceId;
  final String serviceId;
  final String characteristicId;

  ReadParams({
    required this.deviceId,
    required this.serviceId,
    required this.characteristicId,
  });
}

class ReadCharacteristic {
  final BluetoothRepository repository;

  ReadCharacteristic(this.repository);

  Future<List<int>> call(ReadParams params) {
    return repository.read(
      params.deviceId,
      params.serviceId,
      params.characteristicId,
    );
  }
}
