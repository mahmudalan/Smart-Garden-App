import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import '../services/realtime_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Temperature extends StatefulWidget {
  const Temperature({super.key});

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  dynamic nilaiSuhu;
  List<FlSpot> suhuData = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadSuhuData();
    fetchDataPeriodically();

    dataSuhu.onValue.listen((event) {
      final getdataSuhu = event.snapshot;
      setState(() {
        nilaiSuhu = getdataSuhu.value;
      });
    });
  }

  void loadSuhuData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedData = prefs.getStringList('suhuData');
    if (savedData != null) {
      setState(() {
        suhuData = savedData
            .map((e) => FlSpot(
            double.parse(e.split(',')[0]), double.parse(e.split(',')[1])))
            .toList();
      });
    }
  }

  void saveSuhuData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataToSave = suhuData
        .map((e) => '${e.x},${e.y}')
        .toList();
    prefs.setStringList('suhuData', dataToSave);
  }

  void fetchDataPeriodically() {
    timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      if (nilaiSuhu != null) {
        double currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();
        setState(() {
          suhuData.add(FlSpot(currentTime, nilaiSuhu));
          saveSuhuData();
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color cream = const Color(0xffE0CCBE);
    Color darkcream = const Color(0xff747264);
    Color coklat = const Color(0xff3C3633);
    String status;
    String animationFile;
    Color color;
    if (nilaiSuhu != null) {
      if (nilaiSuhu < 30) {
        status = "Cool";
        animationFile = 'lib/assets/cool.json';
        color = Colors.lightBlueAccent;
      } else if (nilaiSuhu >= 30 && nilaiSuhu <= 35) {
        status = "Warm";
        animationFile = 'lib/assets/hot.json';
        color = Colors.lightGreen;
      } else {
        status = "Hot";
        animationFile = 'lib/assets/hot.json';
        color = Colors.red;
      }
    } else {
      // Default values jika nilaiSuhu null (belum diinisialisasi)
      status = "Loading";
      animationFile = 'lib/assets/loading.json';
      color = cream;
    }

    return SingleChildScrollView(
      child: Column(children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 120,
          decoration: BoxDecoration(
              color: coklat, borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, Buddy!',
                    style: TextStyle(
                      color: cream,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'UnigeoMedium',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      color: cream,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'UnigeoMedium',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Cathouse',
                    style: TextStyle(
                      color: darkcream,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'UnigeoMedium',
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              Lottie.asset('lib/assets/cat1.json', height: 110),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        // Aligning the Temperature Dashboard text to the left
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Temperature Dashboard',
                  style: TextStyle(
                      color: coklat,
                      fontFamily: 'UnigeoMedium',
                      fontWeight: FontWeight.bold,
                      fontSize: 23)),
            ],
          ),
        ),
        // Menampilkan tanggal hari ini secara realtime
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                DateFormat('dd MMMM yyyy').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'AgencyFB',
                  color: coklat,
                ),
              ),
              const SizedBox(
                  width:
                  10), // Tambahkan jarak antara tanggal dan waktu
              StreamBuilder<DateTime>(
                stream: Stream.periodic(const Duration(seconds: 1),
                        (i) => DateTime.now()),
                builder: (context, snapshot) {
                  return Text(
                    DateFormat('HH:mm').format(snapshot.data ?? DateTime.now()),
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'AgencyFB',
                      color: coklat,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: cream, width: 2),
              borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Lottie.asset('lib/assets/cat2.json', height: 100),
            Column(
              children: [
                Text(
                  'Welcome to',
                  style: TextStyle(
                      fontFamily: 'UnigeoMedium',
                      color: darkcream,
                      fontSize: 15),
                ),
                Text(
                  'temperature dashboard',
                  style: TextStyle(
                      fontFamily: 'UnigeoMedium',
                      color: darkcream,
                      fontSize: 15),
                ),
                Text(
                  'Smart Cathouse.',
                  style: TextStyle(
                      fontFamily: 'UnigeoMedium',
                      color: darkcream,
                      fontSize: 15),
                ),
                Text(
                  'Enjoy your day, Sir.',
                  style: TextStyle(
                      fontFamily: 'UnigeoMedium',
                      color: darkcream,
                      fontSize: 15),
                ),
              ],
            ),
          ]),
        ),
        Row(
          children: [
            Container(
              height: 190,
              width: 160,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: cream, width: 2)),
              margin:
              const EdgeInsets.only(left: 15, right: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Current',
                      style: TextStyle(
                          color: coklat,
                          fontFamily: 'UnigeoMedium',
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Text('Temperature',
                      style: TextStyle(
                          color: coklat,
                          fontFamily: 'UnigeoMedium',
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '$nilaiSuhu°',
                    style: TextStyle(
                        color: color,
                        fontFamily: 'AgencyFB',
                        fontWeight: FontWeight.bold,
                        fontSize: 60),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Celcius',
                      style: TextStyle(
                          color: coklat,
                          fontFamily: 'UnigeoMedium',
                          fontWeight: FontWeight.bold,
                          fontSize: 16))
                ],
              ),
            ),
            Container(
              height: 190,
              width: 160,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: cream, width: 2)),
              margin: const EdgeInsets.only(right: 15, bottom: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Current',
                    style: TextStyle(
                        color: coklat,
                        fontFamily: 'UnigeoMedium',
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Text(
                    'Status',
                    style: TextStyle(
                        color: coklat,
                        fontFamily: 'UnigeoMedium',
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Lottie.asset(animationFile, height: 100),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    status,
                    style: TextStyle(
                        color: coklat,
                        fontFamily: 'UnigeoMedium',
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Diagram grafik untuk memonitoring nilaiSuhu
        Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                leftTitles: SideTitles(showTitles: true),
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(DateFormat('HH:mm')
                        .format(DateTime.fromMillisecondsSinceEpoch(value.toInt())));
                  },
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black, width: 1),
              ),
              minX: suhuData.isNotEmpty ? suhuData.first.x : 0,
              maxX: suhuData.isNotEmpty ? suhuData.last.x : 0,
              minY: 0,
              maxY: 50,
              lineBarsData: [
                LineChartBarData(
                  spots: suhuData,
                  isCurved: true,
                  colors: [Colors.blue],
                  barWidth: 3,
                  belowBarData: BarAreaData(show: true, colors: [
                    Colors.blue.withOpacity(0.3),
                  ]),
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
