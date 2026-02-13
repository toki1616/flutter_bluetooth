import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ble_connection_state.dart';
import '../../domain/entities/ble_device.dart';
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
