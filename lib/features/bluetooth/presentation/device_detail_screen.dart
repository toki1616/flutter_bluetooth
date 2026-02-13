import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/providers/bluetooth_providers.dart';
import '../domain/entities/ble_connection_state.dart';
import '../domain/entities/ble_device.dart';
import '../domain/usecases/read_characteristic.dart';
import '../domain/usecases/write_characteristic.dart';

class DeviceDetailScreen extends ConsumerWidget {
  final BleDevice device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(connectDeviceProvider(device.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(device.name.isNotEmpty ? device.name : "Unknown Device"),
      ),
      body: connection.when(
        data: (state) {
          return Center(   // ← これが重要
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "状態: $state",
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),

                if (state == BleConnectionState.connected)
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final data = await ref.read(
                            readCharacteristicProvider(
                              ReadParams(
                                deviceId: device.id,
                                serviceId: "YOUR_SERVICE_UUID",
                                characteristicId: "YOUR_CHAR_UUID",
                              ),
                            ).future,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Read: $data")),
                          );
                        },
                        child: const Text("Read Characteristic"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await ref.read(
                            writeCharacteristicProvider(
                              WriteParams(
                                deviceId: device.id,
                                serviceId: "YOUR_SERVICE_UUID",
                                characteristicId: "YOUR_CHAR_UUID",
                                value: [0x01],
                              ),
                            ).future,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Write Done")),
                          );
                        },
                        child: const Text("Write Characteristic"),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("戻る"),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
