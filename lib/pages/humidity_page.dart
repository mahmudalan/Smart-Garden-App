import 'dart:async';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flexible_calendar/flutter_flexible_calendar.dart';
import 'package:intl/intl.dart';
import 'package:lock_system_garden/services/realtime_db.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Humidity extends StatefulWidget {
  const Humidity({super.key});

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> with AutomaticKeepAliveClientMixin {
  dynamic nilaiKelembaban;
  List<FlSpot> humidityData = [];
  final int dataLimit = 24;
  List<String> timeLabels = [];
  bool isDataLoaded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadHumidityData();

    dataKelembaban.onValue.listen((event) {
      final getdataKelembaban = event.snapshot;
      setState(() {
        nilaiKelembaban = getdataKelembaban.value;
        _updateHumidityData();
      });
    });

    // Reset data setiap tengah malam
    Timer.periodic(const Duration(hours: 1), (timer) {
      if (DateTime.now().hour == 0) {
        _resetHumidityData();
      }
    });
  }

  void _updateHumidityData() {
    if (nilaiKelembaban != null) {
      setState(() {
        if (humidityData.length == dataLimit) {
          humidityData.removeAt(0);
          timeLabels.removeAt(0);
        }
        final currentTime = DateTime.now();
        humidityData.add(FlSpot(currentTime.hour + currentTime.minute / 60.0, double.parse(nilaiKelembaban.toString())));
        timeLabels.add(DateFormat('HH:mm').format(currentTime));
        _saveHumidityData();
      });
    }
  }

  void _saveHumidityData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataList = humidityData.map((spot) => jsonEncode({'x': spot.x, 'y': spot.y})).toList();
    await prefs.setStringList('humidityData', dataList);
    await prefs.setStringList('timeLabels', timeLabels);
    await prefs.setString('lastSavedDate', DateFormat('yyyy-MM-dd').format(DateTime.now()));
    print('Data saved: $dataList');
  }

  void _loadHumidityData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dataList = prefs.getStringList('humidityData');
    List<String>? timeList = prefs.getStringList('timeLabels');
    String? lastSavedDate = prefs.getString('lastSavedDate');
    print('Loading data...');

    if (dataList != null && timeList != null && lastSavedDate != null) {
      DateTime lastDate = DateFormat('yyyy-MM-dd').parse(lastSavedDate);
      DateTime currentDate = DateTime.now();

      if (lastDate.isBefore(currentDate)) {
        print('Data is outdated, resetting...');
        _resetHumidityData();
      } else {
        setState(() {
          humidityData = dataList.map((data) {
            Map<String, dynamic> dataMap = jsonDecode(data);
            return FlSpot(dataMap['x'], dataMap['y']);
          }).toList();
          timeLabels = List<String>.from(timeList);
          isDataLoaded = true;
        });
        print('Data loaded: $humidityData');
      }
    } else {
      setState(() {
        isDataLoaded = true;
      });
      print('No data found, set isDataLoaded to true');
    }
  }

  void _resetHumidityData() {
    setState(() {
      humidityData.clear();
      timeLabels.clear();
    });
    _saveHumidityData();
    setState(() {
      isDataLoaded = true;
    });
    print('Data reset');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Tambahkan ini untuk memastikan state tetap terjaga
    Color color;
    String status;
    String animation;
    Color blue = const Color(0xff008DDA);
    Color cyan = const Color(0xff41C9E2);
    Color teal = const Color(0xffACE2E1);
    Color cream = const Color(0xffF7EEDD);
    final DateTime _currentMonth = DateTime.now();

    if (nilaiKelembaban != null) {
      if (nilaiKelembaban >= 40) {
        status = 'Wet';
        color = Colors.lightBlueAccent;
        animation = 'lib/assets/wet.json';
      } else {
        status = 'Dry';
        color = Colors.lightGreen;
        animation = 'lib/assets/dry.json';
      }
    } else {
      status = 'Loading';
      color = Colors.white;
      animation = 'lib/assets/loading.json';
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: blue,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: blue),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello,\nWelcome to',
                      style: TextStyle(
                        fontFamily: 'Balance',
                        fontSize: 16,
                        color: cream,
                      ),
                    ),
                    Text(
                      'Humidity Monitor',
                      style: TextStyle(
                        fontFamily: 'Balance',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: cream,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('MMMM,').format(DateTime.now()),
                          style: TextStyle(
                            fontFamily: 'Balance',
                            fontSize: 15,
                            color: cream,
                          ),
                        ),
                        const SizedBox(width: 5),
                        StreamBuilder<DateTime>(
                          stream: Stream.periodic(
                            const Duration(seconds: 1),
                                (i) => DateTime.now(),
                          ),
                          builder: (context, snapshot) {
                            return Text(
                              DateFormat('HH:mm:ss')
                                  .format(snapshot.data ?? DateTime.now()),
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Balance',
                                color: cream,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Image.asset(
                  'lib/assets/greenhouse.png',
                  height: 80,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: FlutterFlexibleCalendarView(
              showHeader: false,
              headerBgColor: teal,
              calendarType: FlutterFlexibleCalendarType.horizontal,
              showWeekendDay: false,
              disabledPreDay: true,
              colorBg: cream,
              maxLimitYear: 2,
              minLimitYear: 2,
              month: DateTime(_currentMonth.year, _currentMonth.month, 1),
              didResult: (item, datetime) {},
              didDisableItemClick: () {},
              didWeekendItemClick: () {},
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 225,
            width: 375,
            decoration: BoxDecoration(
              border: Border.all(color: cyan),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Current',
                      style: TextStyle(
                        color: blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Balance',
                      ),
                    ),
                    Text(
                      'Humidity',
                      style: TextStyle(
                        color: blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Balance',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Value (%) :',
                      style: TextStyle(
                        color: blue,
                        fontSize: 20,
                        fontFamily: 'Balance',
                      ),
                    ),
                    Text(
                      '$nilaiKelembaban',
                      style: TextStyle(
                        color: color,
                        fontSize: 50,
                        fontFamily: 'Balance',
                      ),
                    ),
                    Text(
                      'Status : $status',
                      style: TextStyle(
                        color: blue,
                        fontSize: 20,
                        fontFamily: 'Balance',
                      ),
                    ),
                  ],
                ),
                Lottie.asset(animation, height: 150),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cyan),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(10),
            child: LineChart(
              LineChartData(
                maxY: 100,
                minY: 0,
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text('Time', style: TextStyle(color: blue, fontFamily: 'Balance'),),
                    sideTitles: const SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 25,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toString(),
                          style: TextStyle(
                            color: blue,
                            fontFamily: 'Balance',
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    axisNameWidget: Text('DHT11 Sensor Monitor', style: TextStyle(color: blue, fontFamily: 'Balance'),),
                    sideTitles: const SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    axisNameWidget: Text('Humidity (%)', style: TextStyle(color: blue, fontFamily: 'Balance'),),
                    sideTitles: const SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                  border: Border.all(color: cyan),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: humidityData,
                    isCurved: true,
                    barWidth: 2,
                    color: blue,
                    belowBarData: BarAreaData(
                      show: true,
                      color: cyan.withOpacity(0.3),
                    ),
                    dotData: const FlDotData(show: true),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        final index = touchedSpot.spotIndex;
                        final value = touchedSpot.y;
                        final time = timeLabels[index];
                        return LineTooltipItem(
                          '$value%\n$time',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }
}
