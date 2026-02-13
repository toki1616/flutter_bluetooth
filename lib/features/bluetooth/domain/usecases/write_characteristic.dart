import '../repositories/bluetooth_repository.dart';

class WriteParams {
  final String deviceId;
  final String serviceId;
  final String characteristicId;
  final List<int> value;

  WriteParams({
    required this.deviceId,
    required this.serviceId,
    required this.characteristicId,
    required this.value,
  });
}

class WriteCharacteristic {
  final BluetoothRepository repository;

  WriteCharacteristic(this.repository);

  Future<void> call(WriteParams params) {
    return repository.write(
      params.deviceId,
      params.serviceId,
      params.characteristicId,
      params.value,
    );
  }
}
