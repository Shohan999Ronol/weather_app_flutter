import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory('90dfe8c16d20d81a6b365f55111568ea');

  Weather? _weather;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getWeather("Mumbai");
  }

  void _getWeather(String cityName) {
    _wf.currentWeatherByCityName(cityName).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/vt1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
          // UI Components
          _buildUI(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSearchDialog(context);
        },
        backgroundColor: Colors.transparent,
        child: Image.asset(
          'assets/search.png', // Replace with your search icon image
          width: 24,
          height: 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _locationHeader(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            _dateTimeInfo(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            _weatherIcon(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _currentTemp(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _extraInfo(),
          ],
        ),
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "  ${DateFormat("d.M.y").format(now)}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 90,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Wind Icon
              Image.asset(
                'assets/wind_speed.png',
                width: 20,
                height: 20,
              ),
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),

              // Humidity Icon
              Image.asset(
                'assets/humidity.png',
                width: 20,
                height: 20,
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),

          // Add a SizedBox for spacing
          const SizedBox(height: 8),

          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              Text(
                "Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search City'),
          content: TextField(
            controller: _cityController,
            decoration: const InputDecoration(
              hintText: 'Enter city name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String cityName = _cityController.text.trim();
                if (cityName.isNotEmpty) {
                  _getWeather(cityName);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}

