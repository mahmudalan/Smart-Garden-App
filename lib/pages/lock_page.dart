import 'package:flutter/material.dart';
import 'package:flutter_flexible_calendar/flutter_flexible_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/realtime_db.dart';

class Lock extends StatefulWidget {
  const Lock({super.key});

  @override
  State<Lock> createState() => _LockState();
}

class _LockState extends State<Lock> {
  dynamic id;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    dataID.onValue.listen((event) {
      final getdataID = event.snapshot;
      setState(() {
        id = getdataID.value;
        if (id != null) {
          _addLogEntry(id);
        }
      });
    });
  }

  Future<void> _addLogEntry(dynamic fingerId) async {
    await _firestore.collection('guestlog').add({
      'fingerId': fingerId,
      'status': 'Registered',
      'doorStatus': 'Door Open',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime _currentMonth = DateTime.now();
    Color blue = const Color(0xff008DDA);
    Color cyan = const Color(0xff41C9E2);
    Color teal = const Color(0xffACE2E1);
    Color cream = const Color(0xffF7EEDD);
    String status;
    String status2;
    String animation;
    if (id != null) {
      if (id == 1 || id == 2 || id == 3 || id == 4 || id == 5 || id == 6) {
        status = 'Registered';
        status2 = 'Door Open';
        animation = 'lib/assets/unlock.png';
      } else {
        status = 'Not Registered';
        status2 = 'Door Lock';
        animation = 'lib/assets/lock.png';
      }
    } else {
      status = 'Loading';
      status2 = 'Loading';
      animation = 'lib/assets/loading.png';
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: blue,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: blue),
            ),
            margin: EdgeInsets.symmetric(horizontal: 15),
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
                      'Lock Door System',
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
                        SizedBox(width: 5),
                        StreamBuilder<DateTime>(
                          stream: Stream.periodic(
                              Duration(seconds: 1), (i) => DateTime.now()),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  width: 173.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cyan)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Fingerprint',
                        style: TextStyle(
                            fontFamily: 'Balance',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blue),
                      ),
                      Text(
                        'Status:',
                        style: TextStyle(
                            fontFamily: 'Balance',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blue),
                      ),
                      const SizedBox(height: 15),
                      Image.asset(
                        'lib/assets/fingerprint.png',
                        height: 60,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Finger ID : $id',
                        style: TextStyle(
                            color: blue,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Balance'),
                      ),
                      Text(
                        'ID Status : : $status',
                        style: TextStyle(
                            color: blue,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Balance'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Container(
                  width: 173.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cyan)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Garden Door',
                        style: TextStyle(
                            fontFamily: 'Balance',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blue),
                      ),
                      Text(
                        'Status:',
                        style: TextStyle(
                            fontFamily: 'Balance',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: blue),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(animation,height: 50,),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Door Status:',
                        style: TextStyle(
                            fontFamily: 'Balance',
                            fontWeight: FontWeight.bold,
                            color: blue),
                      ),
                      Text(
                        status2,
                        style: TextStyle(
                            color: blue,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Balance'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildGuestLogContainer(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String title, String subtitle, Color textColor, Color borderColor, [dynamic id, String? status, String? image]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        width: 157.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Balance',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Balance',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            if (image != null) Image.asset(image, height: 60),
            if (id != null)
              Text(
                'Finger ID : $id',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Balance',
                ),
              ),
            if (status != null)
              Text(
                'Status : $status',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Balance',
                ),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestLogContainer() {
    Color cyan = const Color(0xff41C9E2);
    Color blue = const Color(0xff008DDA);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cyan),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Guest Log',
                style: TextStyle(
                  fontFamily: 'Balance',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: blue,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('guestlog')
                    .orderBy('timestamp', descending: true)
                    .limit(4)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final logs = snapshot.data!.docs;
                  return Column(
                    children: logs.map((log) {
                      final data = log.data() as Map<String, dynamic>;
                      final DateTime timestamp = data['timestamp']?.toDate() ?? DateTime.now();
                      return ListTile(
                        title: Text(
                          'Finger ID ${data['fingerId']} - Status: ${data['status']}',
                          style: TextStyle(color: blue),
                        ),
                        subtitle: Text(
                          'Door Open ${DateFormat('dd/MM/yy HH:mm:ss').format(timestamp)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
