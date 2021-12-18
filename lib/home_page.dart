import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_mqtt/mqtt_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController1;
    late ChartSeriesController _chartSeriesController2;

  @override
  void initState() {
    super.initState();
    chartData = getChartData();
    Timer.periodic(const Duration(seconds: 2), updateDataSource);
  }

  int time = 19;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, (math.Random().nextInt(60) + 30),
        math.Random().nextInt(40) + 20));
    chartData.removeAt(0);
    _chartSeriesController1.updateDataSource(
      addedDataIndex: chartData.length - 1,
      removedDataIndex: 0,
    );
     _chartSeriesController2.updateDataSource(
      addedDataIndex: chartData.length - 1,
      removedDataIndex: 0,
    );
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 42, 20),
      LiveData(1, 47, 20),
      LiveData(2, 43, 20),
      LiveData(3, 49, 20),
      LiveData(4, 54, 20),
      LiveData(5, 41, 20),
      LiveData(6, 58, 20),
      LiveData(7, 51, 20),
      LiveData(8, 98, 20),
      LiveData(9, 50, 20),
      LiveData(10, 53, 50),
      LiveData(11, 72, 50),
      LiveData(12, 86, 50),
      LiveData(13, 52, 50),
      LiveData(14, 94, 50),
      LiveData(15, 92, 50),
      LiveData(16, 86, 50),
      LiveData(17, 72, 50),
      LiveData(18, 94, 50)
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<MqttProvider>(context);
    return SafeArea(
        child: Scaffold(
            body: SfCartesianChart(
                series: <LineSeries<LiveData, int>>[
          LineSeries<LiveData, int>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController1 = controller;
            },
            dataSource: chartData,
            color: const Color.fromRGBO(192, 108, 132, 1),
            xValueMapper: (LiveData sales, _) => sales.time,
            yValueMapper: (LiveData sales, _) => sales.speed,
          ),
          LineSeries<LiveData, int>(
            onRendererCreated: (ChartSeriesController controller) {
              _chartSeriesController2 = controller;
            },
            dataSource: chartData,
            color: Colors.green,
            xValueMapper: (LiveData sales, _) => sales.time,
            yValueMapper: (LiveData sales, _) => sales.temperature,
          )
        ],
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 3,
                    title: AxisTitle(text: 'Time (seconds)')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: 'Internet speed (Mbps)')))));
  }
}

class LiveData {
  LiveData(this.time, this.speed, this.temperature);
  final int time;
  final num speed;
  final num temperature;
}
