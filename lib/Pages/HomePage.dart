import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'LogInPage.dart';

class AdminPage extends StatefulWidget {
  final User user;
  AdminPage({Key key, this.user}) : super(key: key);
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

