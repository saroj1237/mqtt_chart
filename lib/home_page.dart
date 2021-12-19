import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_mqtt/mqtt_provider.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'mqtt_model.dart';

final hamroDatalist = [];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late ChartSeriesController _heatRateController;
  // late ChartSeriesController _temperatureController;
  late StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>
      streamSubscription;
  late MqttProvider server;
  final List<MqttModel> mqttDataList = [
    MqttModel(timestamp: '2021-12-18T16:48:15.219Z', data: [
      Data(value: '50', type: 'Heat Rate'),
      Data(value: '50', type: 'Temperature'),
      Data(value: '50', type: 'SDNN'),
      Data(value: '50', type: 'HVR'),
    ])
  ];
  String myData = '';

  @override
  void initState() {
    server = MqttProvider();
    server.initializeConnection();
    streamSubscription = server.client.updates!.listen((event) {
      final data = event[0].payload as MqttPublishMessage;
      final message =
          MqttPublishPayload.bytesToStringAsString(data.payload.message);
      print(message);
      final jsonMessage = jsonDecode(message);
      setState(() {
        myData = message;
      });
      mqttDataList.add(MqttModel.fromJson(jsonMessage));
      // _heatRateController.updateDataSource(
      //     removedDataIndex: 0, addedDataIndex: mqttDataList.length - 1);
      if (mqttDataList.length > 100) {
        mqttDataList.removeAt(0);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            children: [
              SfCartesianChart(
                trackballBehavior: TrackballBehavior(
                    tooltipDisplayMode: TrackballDisplayMode.floatAllPoints),
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                ),
                primaryXAxis: CategoryAxis(
                    labelRotation: 90,
                    autoScrollingDelta: 10,
                    // desiredIntervals: 10, 
                    autoScrollingMode: AutoScrollingMode.end,
                    title: AxisTitle(text: "Timestamp")),
                primaryYAxis: NumericAxis(
                    desiredIntervals: 8,
                    axisLine: const AxisLine(width: 0),
                    autoScrollingMode: AutoScrollingMode.end,
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: 'Data')),
                series: <LineSeries<MqttModel, String>>[
                  LineSeries<MqttModel, String>(
                      enableTooltip: true,
                      onPointTap: (ChartPointDetails chartPointDetails) {
                        print(chartPointDetails.pointIndex);
                      },
                      legendItemText: 'Heat Rate',
                      legendIconType: LegendIconType.circle,
                      // onRendererCreated: (ChartSeriesController controller) {
                      //   _temperatureChartController = controller;
                      // },
                      dataSource: mqttDataList,
                      color: const Color.fromRGBO(192, 108, 132, 1),
                      xValueMapper: (MqttModel data, _) {
                        DateTime time = DateTime.parse(data.timestamp!);
                        return '${time.hour}:${time.minute}:${time.second}';
                      },
                      yValueMapper: (MqttModel manyData, _) {
                        // print(int.tryParse(manyData.data![1].value));
                        return double.parse(manyData.data?[0].value ?? "40");
                      }),
                  LineSeries<MqttModel, String>(
                      legendItemText: 'Temperature',
                      legendIconType: LegendIconType.circle,
                      dataSource: mqttDataList,
                      color: Colors.red,
                      xValueMapper: (MqttModel data, _) {
                        DateTime time = DateTime.parse(data.timestamp!);
                        return '${time.hour}:${time.minute}:${time.second}';
                      },
                      yValueMapper: (MqttModel manyData, _) {
                        // print(int.tryParse(manyData.data![1].value));
                        return double.parse(manyData.data?[1].value ?? "40");
                      }),
                  LineSeries<MqttModel, String>(
                      legendItemText: 'SDNN',
                      legendIconType: LegendIconType.circle,
                      dataSource: mqttDataList,
                      color: Colors.blue,
                      xValueMapper: (MqttModel data, _) {
                        DateTime time = DateTime.parse(data.timestamp!);
                        return '${time.hour}:${time.minute}:${time.second}';
                      },
                      yValueMapper: (MqttModel manyData, _) {
                        return double.parse(manyData.data?[2].value ?? "40");
                      }),
                  LineSeries<MqttModel, String>(
                      legendItemText: 'HVR',
                      legendIconType: LegendIconType.circle,
                      dataSource: mqttDataList,
                      color: Colors.green,
                      xValueMapper: (MqttModel data, _) {
                        DateTime time = DateTime.parse(data.timestamp!);
                        return '${time.hour}:${time.minute}:${time.second}';
                      },
                      yValueMapper: (MqttModel manyData, _) {
                        return double.parse(manyData.data?[3].value ?? "40");
                      }),
                ],
              ),
            ],
          ),
        ));
  }
  // return Scaffold(
  //     body: SingleChildScrollView(
  //   child: Column(
  //     children: [Text(myData)],
  //   ),
  // ));
}
