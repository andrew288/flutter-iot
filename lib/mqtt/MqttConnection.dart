import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/services.dart';

Future<MqttServerClient> connect() async {
  final client = MqttServerClient.withPort(
      "a34bt8gk372w9w-ats.iot.us-east-2.amazonaws.com", '', 8883);
  client.secure = true;
  client.keepAlivePeriod = 20;
  client.setProtocolV311();
  client.logging(on: false);

  ByteData rootCA = await rootBundle.load("assets/AmazonRootCA1.pem");
  ByteData deviceCert = await rootBundle.load('assets/certificate.pem.crt');
  ByteData privateKey = await rootBundle.load('assets/private.pem.key');

  SecurityContext clientContext = SecurityContext.defaultContext;
  clientContext.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
  clientContext.useCertificateChainBytes(deviceCert.buffer.asUint8List());
  clientContext.usePrivateKeyBytes(privateKey.buffer.asUint8List());
  client.securityContext = clientContext;

  try {
    await client.connect();
    print('conectado');
    //subscribeToTopic(client, 'TOPIC_RONY');
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
    throw Exception('Error connecting to MQTT server');
  }

  if (client.connectionStatus?.state == MqttConnectionState.connected) {
    print("Se establecio la coneccion MQTT");
  } else {
    print("No se establecio la conexion MQTT");
  }

  return client;
}

Future<void> publishTopic(
    MqttServerClient client, String message, String topic) async {
  final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
  builder.addString(message);
  try {
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    print('Message published to topic $topic');
  } catch (e) {
    print('Error publishing message: $e');
  }
}
