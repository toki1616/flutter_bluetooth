import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ble_connection_state.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/usecases/read_characteristic.dart';
import '../../domain/usecases/subcribe_params.dart';
import '../../domain/usecases/write_characteristic.dart';
import '../../infrastructure/services/bluetooth_permission_service.dart';
import '../../infrastructure/datasources/reactive_ble_datasource.dart';
import '../../infrastructure/repositories/bluetooth_repository_impl.dart';
import '../../domain/usecases/scan_devices.dart';
import '../../domain/usecases/connect_device.dart';

/// Permission Service
final bluetoothPermissionServiceProvider =
Provider((ref) => BluetoothPermissionService());

/// Permission FutureProvider
final bluetoothPermissionFutureProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(bluetoothPermissionServiceProvider);
  return service.requestPermissions();
});

/// BLE Datasource
final bleDatasourceProvider = Provider((ref) => ReactiveBleDatasource());

/// Repository
final bluetoothRepositoryProvider = Provider(
      (ref) => BluetoothRepositoryImpl(ref.read(bleDatasourceProvider)),
);

/// Scan
final scanDevicesProvider = StreamProvider<List<BleDevice>>(
      (ref) => ScanDevices(ref.read(bluetoothRepositoryProvider))(),
);

/// Connect
final connectDeviceProvider = StreamProvider.family<BleConnectionState, String>(
      (ref, deviceId) =>
      ConnectDevice(ref.read(bluetoothRepositoryProvider))(deviceId),
);

/// read
final readCharacteristicProvider =
FutureProvider.family<List<int>, ReadParams>((ref, params) {
  final repo = ref.read(bluetoothRepositoryProvider);
  return ReadCharacteristic(repo)(params);
});

/// write
final writeCharacteristicProvider =
FutureProvider.family<void, WriteParams>((ref, params) {
  final repo = ref.read(bluetoothRepositoryProvider);
  return WriteCharacteristic(repo)(params);
});

/// discoverService
final discoverServicesProvider =
FutureProvider.family<List<DiscoveredService>, String>((ref, deviceId) async {
  final repo = ref.read(bluetoothRepositoryProvider);
  return repo.discoverServices(deviceId);
});

// subscribe
final subscribeProvider =
StreamProvider.family<List<int>, SubscribeParams>((ref, params) {
  final repo = ref.read(bluetoothRepositoryProvider);
  return repo.subscribe(
    params.deviceId,
    params.serviceId,
    params.characteristicId,
  );
});
