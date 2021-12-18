import 'dart:async';
import 'dart:io';
import 'package:flutter_mqtt/main.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client =
    MqttServerClient.withPort("3.249.226.249", 'mqtt.eclipse.org', 8883);

class MqttService {
  mqttInitialize() async {
    client.logging(on: true);
    // client.onConnected = onConnected;
    client.keepAlivePeriod = 20;
    // client.onDisconnected = onDisconnected;
    // client.pongCallback = onPong;
    client.connect('fortest', 'mqtttest');
    client.onConnected = onConnected();
  }

  onConnected() {
    // client.subscribe("fortest", MqttQos.exactlyOnce);
    // if (client.connectionStatus!.disconnectionOrigin ==
    //     MqttDisconnectionOrigin.solicited) {
    //   client.disconnect();
    // }
    // client.updates!.listen((event) {
    //   final message = event[0].payload as MqttPublishMessage;
    //   final pt =
    //       MqttPublishPayload.bytesToStringAsString(message.payload.message);
    // });
    if(client.connectionStatus!.state==MqttConnectionState.connected){
      print("connected");
    }
  }

  onDisconnected() {
    client.unsubscribe('fortest');
    // ignore: avoid_print
    print("disconnected---------");
    exit(-1);
  }

  onPong() {
    // ignore: avoid_print
    print('received something');
  }
}
