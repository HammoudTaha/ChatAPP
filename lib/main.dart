import 'package:chatapp/core/utils/di.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/config/config_loading.dart';
import 'features/app.dart';
import 'firebase_options.dart';

//firebase emulators:start --import=./firestore-data --export-on-exit
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDI();
  await getIt.allReady();
  FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);
  runApp(const App());
  configLoading();
}
//CONms2aFubbyojXn