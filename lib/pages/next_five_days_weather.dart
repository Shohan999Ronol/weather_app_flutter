import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class NextFiveDaysWeather extends StatefulWidget {
  final String cityName;

  const NextFiveDaysWeather({Key? key, required this.cityName}) : super(key: key);

  @override
  _NextFiveDaysWeatherState createState() => _NextFiveDaysWeatherState();
}

class _NextFiveDaysWeatherState extends State<NextFiveDaysWeather> {
  final WeatherFactory _wf = WeatherFactory('90dfe8c16d20d81a6b365f55111568ea');
  List<Weather>? _nextFiveDaysWeather;

  @override
  void initState() {
    super.initState();
    _getNextFiveDaysWeather(widget.cityName);
  }

  void _getNextFiveDaysWeather(String cityName) {
    _wf.fiveDayForecastByCityName(cityName).then((weather) {
      setState(() {
        _nextFiveDaysWeather = weather;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Five Days Weather'),
      ),
      body: Column(
        children: [
          _buildWeatherList(),
          _buildDayAverages(),
        ],
      ),
    );
  }

  Widget _buildWeatherList() {
    if (_nextFiveDaysWeather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: _nextFiveDaysWeather!.length,
        itemBuilder: (context, index) {
          Weather dayWeather = _nextFiveDaysWeather![index];

          return ListTile(
            title: Text(
              DateFormat("EEEE, d.M.y").format(dayWeather.date!),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Temperature: ${dayWeather.temperature?.celsius?.toStringAsFixed(0)}° C'),
                Text('Description: ${dayWeather.weatherDescription}'),
                const SizedBox(height: 8),
              ],
            ),
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "http://openweathermap.org/img/wn/${dayWeather.weatherIcon}@2x.png",
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDayAverages() {
    if (_nextFiveDaysWeather == null || _nextFiveDaysWeather!.isEmpty) {
      return Container(); // Return an empty container if there's no data
    }

    double avgTemp = _nextFiveDaysWeather!
        .map((weather) => weather.temperature?.celsius ?? 0)
        .reduce((value, element) => value + element) /
        _nextFiveDaysWeather!.length;

    double avgWind = _nextFiveDaysWeather!
        .map((weather) => weather.windSpeed ?? 0)
        .reduce((value, element) => value + element) /
        _nextFiveDaysWeather!.length;

    double avgHumidity = _nextFiveDaysWeather!
        .map((weather) => weather.humidity ?? 0)
        .reduce((value, element) => value + element) /
        _nextFiveDaysWeather!.length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Averages for the Next Five Days:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAverageInfo('Temperature', avgTemp, '° C'),
              _buildAverageInfo('Wind Speed', avgWind, 'm/s'),
              _buildAverageInfo('Humidity', avgHumidity, '%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAverageInfo(String title, double value, String unit) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          '${value.toStringAsFixed(2)} $unit',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
