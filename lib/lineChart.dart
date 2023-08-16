import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class LineChart extends StatefulWidget {
  final List<Map<String, dynamic>>data;
  const LineChart({super.key, required this.data});

  @override
  State<LineChart> createState() => _LineChartState();
}

class _SalesData {
  _SalesData(this.date, this.amount);

  final String date;
  final int amount;
}

class _LineChartState extends State<LineChart> {
  @override
  Widget build(BuildContext context) {
    List<_SalesData> data = widget.data.reversed.toList().sublist(widget.data.length-5).map((Map<String, dynamic> e) =>
        _SalesData(e["transactionDate"]?.day.toString()?? "0",
            double.parse(e["AvlBal"]).toInt())).toList();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Half yearly sales analysis'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                SplineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.date,
                    yValueMapper: (_SalesData sales, _) => sales.amount,
                    name: 'Sales',
                    markerSettings:
                        MarkerSettings(shape: DataMarkerType.diamond),
                    // pointColorMapper:((_SalesData sales, _) => sales.sales <=30?Color.fromARGB(0, 210, 26, 26): Color.fromARGB(0, 26, 210, 48)),
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        borderRadius: 5,
                        labelPosition: ChartDataLabelPosition.outside,
                        labelAlignment: ChartDataLabelAlignment.bottom,
                        alignment: ChartAlignment.near))
              ]),
        ]));
  }
}
