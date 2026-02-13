class SubscribeParams {
  final String deviceId;
  final String serviceId;
  final String characteristicId;

  SubscribeParams({
    required this.deviceId,
    required this.serviceId,
    required this.characteristicId,
  });
}
