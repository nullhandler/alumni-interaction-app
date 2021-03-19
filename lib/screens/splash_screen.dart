
import 'package:flutter/material.dart';
import 'package:flutter_forum/screens/list_post.dart';
import 'package:flutter_forum/screens/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    splash();
  }

  splash() async {
    Future.delayed(const Duration(seconds: 3), () {
      checkStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo.png',
                //width: MediaQuery.of(context).size.width * 0.9,
                //height: MediaQuery.of(context).size.height * 0.6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "SCAD CET",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Text(
              "Forum Interaction System",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.green),
              ),
            )
          ],
        ),
      ),
    );
  }

  checkStatus() async {
    String token = await _flutterSecureStorage.read(key: 'token');
    if (token != null) {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ListPost(token)));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(token)));
    }
  }

  // getAgentDash(String token) async {
  //   var resp = await http.get(VOTER_DASH, headers: {'Authorization': token});
  //   var js = jsonDecode(resp.body);
  //   if (js['errors'] == null) {
  //     return UserDashItem.fromJson(js['data']);
  //   } else {
  //     await _flutterSecureStorage.delete(key: 'token');
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => ChoiceScreen()),
  //     );
  //     return;
  //   }
  // }
}
