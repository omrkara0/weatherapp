import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  String city;
  HomePage({Key? key, required this.city}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(city);
}

class _HomePageState extends State<HomePage> {
  String city;
  _HomePageState(this.city);

  var name;
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var pressure;
  var clouds;

  Future getWeather() async {
    final url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=" +
        city +
        "&units=metric&appid=d7a4fa95b94ae1ebc8fe28d791a1b9e9");

    http.Response response = await http.get(url);
    var results = jsonDecode(response.body);

    setState(() {
      name = results["name"];
      temp = results["main"]["temp"];
      description = results["weather"][0]["description"];
      currently = results["weather"][0]["main"];
      humidity = results["main"]["humidity"];
      windSpeed = results["wind"]["speed"];
      pressure = results["main"]["pressure"];
      clouds = results["clouds"]["all"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final still = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    final still2 = TextStyle(
      fontSize: 15,
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
            onPressed: () => getWeather,
            icon: Icon(
              Icons.refresh,
              size: 30,
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(image: buildBack()),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Spacer(),
            Expanded(
                child: name != null
                    ? Text(name,
                        style: GoogleFonts.lato(
                            color: Colors.white.withOpacity(0.9), fontSize: 40))
                    : CircularProgressIndicator()),
            Spacer(
              flex: 1,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  temp != null
                      ? Text(temp.toString() + " °C",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 50))
                      : CircularProgressIndicator(),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      getIcon(),
                      SizedBox(
                        width: 15,
                      ),
                      currently != null && description != null
                          ? Text(
                              currently.toString() +
                                  " / " +
                                  description.toString(),
                              style: GoogleFonts.lato(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 25))
                          : CircularProgressIndicator(),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Wind",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 25)),
                      SizedBox(
                        height: 10,
                      ),
                      windSpeed != null
                          ? Text(windSpeed.toString(),
                              style: GoogleFonts.lato(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 20))
                          : CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text("km/h",
                          style: GoogleFonts.lato(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 20)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Clouds",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 25)),
                      SizedBox(
                        height: 10,
                      ),
                      clouds != null
                          ? Text(clouds.toString(),
                              style: GoogleFonts.lato(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 20))
                          : CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text("%",
                          style: GoogleFonts.lato(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 20))
                    ],
                  ),
                  Column(
                    children: [
                      Text("Humidity",
                          style: GoogleFonts.lato(
                              color: Colors.white, fontSize: 25)),
                      SizedBox(
                        height: 10,
                      ),
                      humidity != null
                          ? Text(humidity.toString(),
                              style: GoogleFonts.lato(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 20))
                          : CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text("%",
                          style: GoogleFonts.lato(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 20))
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  DecorationImage buildBack() {
    if (currently.toString() == "Clouds") {
      return DecorationImage(
          image: AssetImage("assets/images/cloudy.jpg"), fit: BoxFit.fill);
    } else if (currently.toString() == "Sunny") {
      return DecorationImage(
          image: AssetImage("assets/images/sunny.jpg"), fit: BoxFit.fill);
    } else if (currently.toString() == "Rain") {
      return DecorationImage(
          image: AssetImage("assets/images/rainy.jpg"), fit: BoxFit.fill);
    } else if (currently.toString() == "Mist") {
      return DecorationImage(
          image: AssetImage("assets/images/misty.jpg"), fit: BoxFit.fill);
    }

    return DecorationImage(
        image: AssetImage("assets/images/cloudy.jpg"), fit: BoxFit.fill);
  }

  Widget getIcon() {
    if (currently.toString() == "Clouds") {
      if (description.toString() == "broken clouds") {
        return FaIcon(
          FontAwesomeIcons.cloudSun,
          color: Colors.white,
          size: 30,
        );
      }
      return FaIcon(
        FontAwesomeIcons.cloud,
        color: Colors.white,
        size: 30,
      );
    } else if (currently.toString() == "Sunny") {
      return FaIcon(
        FontAwesomeIcons.sun,
        color: Colors.white,
        size: 30,
      );
    } else if (currently.toString() == "Rain") {
      return FaIcon(
        FontAwesomeIcons.cloudRain,
        color: Colors.white,
        size: 30,
      );
    } else if (currently.toString() == "Mist") {
      return FaIcon(
        FontAwesomeIcons.cloudversify,
        color: Colors.white,
        size: 30,
      );
    }

    return CircularProgressIndicator();
  }
}
