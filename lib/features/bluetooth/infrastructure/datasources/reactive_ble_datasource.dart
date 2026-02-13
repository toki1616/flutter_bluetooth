import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class ReactiveBleDatasource {
  final FlutterReactiveBle ble = FlutterReactiveBle();

  /// スキャン
  Stream<List<DiscoveredDevice>> scan() {
    final devices = <String, DiscoveredDevice>{};

    return ble.scanForDevices(withServices: []).map((device) {
      devices[device.id] = device;
      return devices.values.toList();
    });
  }

  /// 安定した接続処理
  Stream<DeviceConnectionState> connect(String deviceId) async* {
    await for (final state in ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    )) {
      yield state.connectionState;

      if (state.connectionState == DeviceConnectionState.connected) {
        // 接続後にサービス探索（安定化のため必須）
        await ble.discoverServices(deviceId);
      }
    }
  }

  /// サービス一覧取得
  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    return await ble.discoverServices(deviceId);
  }

  /// 読み取り
  Future<List<int>> read(String deviceId, String serviceId, String characteristicId) async {
    final characteristic = QualifiedCharacteristic(
      deviceId: deviceId,
      serviceId: Uuid.parse(serviceId),
      characteristicId: Uuid.parse(characteristicId),
    );
    return ble.readCharacteristic(characteristic);
  }

  /// 書き込み
  Future<void> write(String deviceId, String serviceId, String characteristicId, List<int> value) async {
    final characteristic = QualifiedCharacteristic(
      deviceId: deviceId,
      serviceId: Uuid.parse(serviceId),
      characteristicId: Uuid.parse(characteristicId),
    );
    await ble.writeCharacteristicWithResponse(characteristic, value: value);
  }

  /// Notify 購読
  Stream<List<int>> subscribe(String deviceId, String serviceId, String characteristicId) {
    final characteristic = QualifiedCharacteristic(
      deviceId: deviceId,
      serviceId: Uuid.parse(serviceId),
      characteristicId: Uuid.parse(characteristicId),
    );
    return ble.subscribeToCharacteristic(characteristic);
  }
}
