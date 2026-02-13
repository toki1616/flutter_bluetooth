import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/bluetooth/presentation/bluetooth_screen.dart';
import 'features/bluetooth/presentation/permission_denied_screen.dart';
import 'features/bluetooth/application/providers/bluetooth_providers.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Bluetooth + Location の権限チェック
    final permission = ref.watch(bluetoothPermissionFutureProvider);

    return MaterialApp(
      title: 'Bluetooth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: permission.when(
        data: (granted) {
          if (granted) {
            // 権限が許可されたら BluetoothScreen を表示
            return const BluetoothScreen();
          } else {
            // 拒否されたら PermissionDeniedScreen を表示
            return const PermissionDeniedScreen();
          }
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Scaffold(
          body: Center(child: Text("Error: $e")),
        ),
      ),
    );
  }
}
