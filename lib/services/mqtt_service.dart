import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils.dart';
import '../models/mqtt_model.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttService extends GetxService {
  late MqttBrowserClient _client;

  final Utils _utils = Get.put(Utils());

  final MqttModel _mqttModel = MqttModel(
      brokerAddress: 'ws://192.168.137.1',
      port: 8083,
      clientId: 'flutter_client',
      username: 'denyryn',
      password: '12345');

  // Observable connection state with a more reliable state tracking
  RxBool isConnected = false.obs;
  RxBool isConnecting = false.obs;

  final _messageCallbacks = <String, Function(String)>{};

  String get broker => _mqttModel.brokerAddress;
  int get port => _mqttModel.port;
  String get clientId => _mqttModel.clientId;
  String get username => _mqttModel.username;
  String get password => _mqttModel.password;

  Future<void> _initialize() async {
    _client = MqttBrowserClient(broker, clientId, maxConnectionAttempts: 3);
    _client.logging(on: false);
    _client.port = port;
    _client.keepAlivePeriod = 120;
    _client.connectTimeoutPeriod = 10000; // 10 seconds
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;

    _client.connectionMessage = MqttConnectMessage()
        .authenticateAs(username, password)
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
  }

  // Add connection retry logic
  Future<bool> connect() async {
    await _initialize();

    if (isConnecting.value) {
      print('Connection attempt already in progress');
      return false;
    }

    if (isConnected.value) {
      print('Already connected');
      return true;
    }

    _utils.refreshVariableValue(isConnecting, true);

    try {
      print('Connecting to $broker on port $port...');
      await _client.connect();

      // Ensure connection is successful before setting isConnected
      if (!(_client.connectionStatus?.state == MqttConnectionState.connected)) {
        print('Connection failed: ${_client.connectionStatus?.state}');
        return false;
      }

      _setupMessageHandler();
      print('Connected successfully!');
      return true;
    } catch (e) {
      print('Error during connection: $e');
      _client.disconnect();
      return false;
    } finally {
      _utils.refreshVariableValue(isConnecting, false);
    }
  }

  void onConnected() {
    print('Connected to broker!');

    _utils.refreshVariableValue(isConnected,
        _client.connectionStatus?.state == MqttConnectionState.connected);
    print("isConnected value : ${isConnected.value}");

    Get.snackbar('MQTT Connection', 'Connected to broker!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white);
  }

  void onDisconnected() {
    print('Disconnected from broker');

    _utils.refreshVariableValue(isConnected,
        _client.connectionStatus?.state == MqttConnectionState.connected);
    print("isConnected value : ${isConnected.value}");

    _messageCallbacks.clear();

    Get.snackbar('MQTT Connection', 'Disconnected from broker!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }

  Future<bool> publish(String topic, String message) async {
    if (!isConnected.value) {
      print('Cannot publish. Client is not connected. Reconnecting...');
      // Try to reconnect
      final connected = await connect();
      if (!connected) {
        return false;
      }
    }

    try {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      _client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
      print('Published message to $topic: $message');
      return true;
    } catch (e) {
      print('Error publishing message: $e');
      return false;
    }
  }

  Future<bool> subscribe(String topic) async {
    if (!isConnected.value) {
      print('Cannot subscribe. Client is not connected. Reconnecting...');
      // Try to reconnect
      final connected = await connect();
      if (!connected) {
        return false;
      }
    }

    try {
      _client.subscribe(topic, MqttQos.atMostOnce);
      print('Subscribed to topic: $topic');
      return true;
    } catch (e) {
      print('Error subscribing to topic: $e');
      return false;
    }
  }

  void registerCallback(String topic, Function(String) callback) {
    _messageCallbacks[topic] = callback;
    if (isConnected.value) {
      subscribe(topic);
    }
  }

  void _setupMessageHandler() {
    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      final MqttPublishMessage message = event[0].payload as MqttPublishMessage;
      final String topic = event[0].topic;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      if (_messageCallbacks.containsKey(topic)) {
        _messageCallbacks[topic]?.call(payload);
      }
      print('Received message on $topic: $payload');
    });
  }

  void unsubscribe(String topic) {
    if (isConnected.value) {
      _client.unsubscribe(topic);
      _messageCallbacks.remove(topic);
      print('Unsubscribed from topic: $topic');
    }
  }

  void disconnect() {
    if (isConnected.value) {
      print('Disconnecting from broker...');
      _messageCallbacks.clear();
      _client.disconnect();
    }
  }
}
