import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_mqtt/main.dart';
import 'package:flutter_mqtt/mqtt_model.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttProvider with ChangeNotifier {
  final List<MqttModel> mqttDataList = [];

  final client =
      MqttServerClient.withPort("3.249.226.249", 'mqtt.eclipse.org', 8883);

  onConnected() {
    client.onConnected = () {
      // ignore: avoid_print
      print("connected state");
      client.updates!.listen((event) {
        final data = event[0].payload as MqttPublishMessage;
        final message =
            MqttPublishPayload.bytesToStringAsString(data.payload.message);
        final jsonMessage = jsonDecode(message);
        mqttDataList.add(MqttModel.fromJson(jsonMessage));
      });
    };
  }
}
