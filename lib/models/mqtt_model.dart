class MqttModel {
  final String brokerAddress;
  final int port;
  final String clientId;
  final String username;
  final String password;

  MqttModel({
    required this.brokerAddress,
    required this.port,
    required this.clientId,
    required this.username,
    required this.password,
  });
}
