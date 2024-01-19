import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';

Future<MqttServerClient> connect() async {
  // final client = MqttServerClient.withPort(
  //     "ag20q59pra3c4-ats.iot.us-east-1.amazonaws.com", '1', 8883);
  final client = MqttServerClient.withPort(
      "a34bt8gk372w9w-ats.iot.us-east-2.amazonaws.com", "1", 8883);
  client.secure = true;
  client.keepAlivePeriod = 20;
  // client.setProtocolV311();
  client.logging(on: false);

  // ByteData rootCA =
  //     await rootBundle.load("assets/credentials/AmazonRootCA1.pem");
  // ByteData deviceCert =
  //     await rootBundle.load('assets/credentials/Certificate.pem.crt');
  // ByteData privateKey =
  //     await rootBundle.load('assets/credentials/Private.pem.key');
  ByteData rootCA = await rootBundle.load("assets/AmazonRootCA1.pem");
  ByteData deviceCert = await rootBundle.load('assets/Certificate.pem.crt');
  ByteData privateKey = await rootBundle.load('assets/Private.pem.key');

  SecurityContext clientContext = SecurityContext.defaultContext;
  // clientContext.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
  clientContext.setTrustedCertificatesBytes(rootCA.buffer.asUint8List());
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

void publishTopic(MqttServerClient client, String message, String topic) {
  final MqttPayloadBuilder builder = MqttPayloadBuilder();
  builder.addString(message);
  try {
    int valueClient =
        client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    print('Message published to topic $topic, number $valueClient');
  } catch (e) {
    print('Error publishing message: $e');
  }
}
