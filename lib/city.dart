import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Homepage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class City extends StatefulWidget {
  const City({Key? key}) : super(key: key);

  @override
  _CityState createState() => _CityState();
}

class _CityState extends State<City> {
  var city;
  bool varmi = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hava Durumu Bul",
              style: GoogleFonts.lato(fontSize: 25),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: TextField(
                  controller: _controller,
                  onChanged: (text) {
                    city = text;
                  },
                  decoration: InputDecoration(
                      hintText: "Şehir...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)))),
            ),
            FlatButton(
              onPressed: () async {
                varmi = await InternetConnectionChecker().hasConnection;
                // final text = varmi ? null : "İnternet Yok";

                if (varmi) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(city: city),
                      ));
                  _controller.clear();
                } else if (varmi = false) {
                  showSimpleNotification(
                      Text(
                        "İnternet Bulunamadı",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      background: Colors.red);
                }
              },
              child: Text(
                "BUL",
                style: GoogleFonts.lato(fontSize: 20),
              ),
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            )
          ],
        ),
      ),
    );
  }
}
