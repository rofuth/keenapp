import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keenapp/constants/constants.dart';
import 'package:keenapp/provider/getMobileinfo.dart';

import 'package:keenapp/provider/user_Provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Timer Timeresult;
  var _duration = new Duration(seconds: 3);
  startTime() async {
    String _deviceId;

    getMobileINF getinfo = getMobileINF();
    var _data = await getinfo.initPlatformState();
    _deviceId = _data.toString();

    var userProvider = Provider.of<UserProvider>(context, listen: false);
    if (await userProvider.chkVeriflyMobile(_deviceId, 'keenapp') == true) {
      Timeresult = new Timer(_duration, navigationPage);
    } else {
      Timeresult = new Timer(_duration, navigationErroePage);
    }

    return Timeresult;
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(SIGN_IN);
  }

  void navigationErroePage() {
    Navigator.of(context).pushReplacementNamed(ERROR_VERIFLYMOBILE);
  }

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();
    setState(() {
      _visible = !_visible;
    });

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: new Image.asset(
                    'assets/images/powered_by.png',
                    height: 25.0,
                    fit: BoxFit.scaleDown,
                  ))
            ],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/images/logo.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
