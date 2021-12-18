import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client =
    MqttServerClient.withPort("3.249.226.249", 'mqtt.eclipse.org', 8883);

void main(List<String> args) async {
  client.logging(on: true);
  client.onConnected = onConnected;
  client.keepAlivePeriod = 20;
  client.onDisconnected = onDisconnected;
  client.pongCallback = onPong;

  try {
    final status = await client.connect('tester', 'mqtttest');
    print(status);
  } on SocketException catch (e) {
    print(e);
    client.disconnect();

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("we are conntected");
    } else {
      client.disconnect();
      exit(-1);
    }
  }
}

onConnected() {
  print('successfull connected');
   client.subscribe("fortest",MqttQos.exactlyOnce);
  if (client.connectionStatus!.disconnectionOrigin ==
      MqttDisconnectionOrigin.solicited) {
    // client.disconnect();
  }
  client.updates!.listen((event) { 
  final message =   event[0].payload as MqttPublishMessage;
  final pt = MqttPublishPayload.bytesToStringAsString(message.payload.message); 

  print("<<-------------------$pt-------------------------->>");
  });
}

onDisconnected() {
  
  client.unsubscribe('fortest');
  print("disconnected---------");
  exit(-1);
}
onPong(){
 print('received something');

}
