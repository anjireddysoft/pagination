
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pagination_flutter/home_page.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isAuth = false;
  void checkBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      print("error biome trics $e");
    }
    print("biometric is available: $canCheckBiometrics");
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      print("error enumerate biometrics $e");
    }
    print("following biometrics are available");
    if (availableBiometrics.isNotEmpty) {
      availableBiometrics.forEach((ab) {
        print("\ttech: $ab");
      });
    } else {
      print("no biometrics are available");
    }

    bool authenticated = false;

    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Touch your finger on the sensor to login',
          useErrorDialogs: true,
          stickyAuth: false
        // androidAuthStrings:AndroidAuthMessages(signInTitle: "Login to HomePage")
      );
    } catch (e) {
      print("error using biometric auth: $e");
    }

    setState(() {
      isAuth = authenticated ? true : false;
    });
if(authenticated==true){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
}
    print("authenticated: $authenticated");
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('BioAuthentication'),
          ),
          body: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
               MaterialButton(
                splashColor: Colors.pinkAccent,
                color: Colors.black,
                child: new Text(
                  "Authentiate",
                  style: new TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                onPressed: checkBiometric,
              ),
              new Expanded(
                child: Container(),
              ),
              isAuth == true
                  ? Text(
                "Authenticated",
                softWrap: true,
                style: new TextStyle(fontSize: 30.0, color: Colors.black),
              )
                  : Text(
                "Not Authenticated",
                softWrap: true,
                style: new TextStyle(fontSize: 30.0, color: Colors.black),
              ),
              new Expanded(
                child: Container(),
              ),
            ],
          ),
        ));
  }
}