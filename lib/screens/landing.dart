import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_project/model/user.dart';
import 'package:test_flutter_project/screens/login.dart';
import 'package:test_flutter_project/screens/newsfeed.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocalUser user = Provider.of<LocalUser>(context);
    final bool _isLogged = user != null;

    return _isLogged ? NewsFeedPage() : LoginPage();
  }
}
