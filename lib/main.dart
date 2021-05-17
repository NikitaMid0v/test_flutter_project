import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_project/screens/landing.dart';
import 'package:test_flutter_project/screens/login.dart';
import 'package:test_flutter_project/services/auth.dart';

import 'model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ArchtrApp());
}

class ArchtrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LocalUser>.value(
      value: AuthService().currentUser,
      child: MaterialApp(
        title: 'ARCHTR',
        home: LandingPage(),
      ),
    );
  }

}
