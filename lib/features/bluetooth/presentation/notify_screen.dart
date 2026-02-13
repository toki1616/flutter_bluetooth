import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/providers/bluetooth_providers.dart';
import '../domain/usecases/subcribe_params.dart';

class NotifyScreen extends ConsumerWidget {
  final String deviceId;
  final String serviceId;
  final String characteristicId;

  const NotifyScreen({
    super.key,
    required this.deviceId,
    required this.serviceId,
    required this.characteristicId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(subscribeProvider(
      SubscribeParams(
        deviceId: deviceId,
        serviceId: serviceId,
        characteristicId: characteristicId,
      ),
    ));

    return Scaffold(
      appBar: AppBar(title: const Text('Notify')),
      body: stream.when(
        data: (value) => Center(child: Text('Notify: $value')),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
