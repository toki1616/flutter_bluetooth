import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/providers/bluetooth_providers.dart';
import 'device_detail_screen.dart';

class BluetoothScreen extends ConsumerWidget {
  const BluetoothScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scan = ref.watch(scanDevicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("BLE デバイス一覧")),
      body: scan.when(
        data: (devices) {
          if (devices.isEmpty) {
            return const Center(child: Text("No devices found"));
          }

          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final d = devices[index];

              return ListTile(
                title: Text(d.name.isNotEmpty ? d.name : "Unknown Device"),
                subtitle: Text(d.id),
                onTap: () {
                  // ★ 接続開始（安定化された connectDeviceProvider を起動）
                  ref.read(connectDeviceProvider(d.id));

                  // ★ 詳細画面へ遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeviceDetailScreen(device: d),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
