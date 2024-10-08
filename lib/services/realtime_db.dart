import 'package:firebase_database/firebase_database.dart';

final database = FirebaseDatabase.instance.ref();
final dataID = database.child('dataID');
final dataSuhu = database.child('dataSuhu');
final dataKelembaban = database.child('dataKelembaban');
final dataSoil = database.child('dataSoil');