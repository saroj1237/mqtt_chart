import 'dart:convert';
import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter_mqtt/main.dart';
import 'package:flutter_mqtt/mqtt_model.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttProvider {
  late MqttServerClient client;

  MqttProvider() {
    client =
        MqttServerClient.withPort("3.249.226.249", 'mqtt.eclipse.org', 8883);
    client.pongCallback = onPong;
    client.onConnected = () {
      client.subscribe("fortest", MqttQos.exactlyOnce);
      // ignore: avoid_print
      print("connected state");
    };
  }

  onPong() {
    print('received something');
  }

  void initializeConnection() async {
    try {
      final status = await client.connect('tester', 'mqtttest');
      print(status);
    } on SocketException catch (e) {
      print(e);
      client.disconnect();

      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        print("we are conntected");
      } else {
        print("error has occured");
        client.disconnect();
        // exit(-1);
      }
    }
  }
}

// void main(List<String> args) {
//   final List<MqttModel> mqttDataList = [];

//   MqttProvider server = MqttProvider();
//   server.initializeConnection();
//   server.client.updates!.listen((event) {
//     final data = event[0].payload as MqttPublishMessage;
//     final message =
//         MqttPublishPayload.bytesToStringAsString(data.payload.message);
//     final jsonMessage = jsonDecode(message);
//     mqttDataList.add(MqttModel.fromJson(jsonMessage));
//   });
// }
