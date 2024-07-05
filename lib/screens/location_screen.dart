import 'package:flutter/material.dart';
import 'package:weather/services/weather.dart';
import 'package:weather/screens/city_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.locationWeather});

  final dynamic locationWeather;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();

  late int temperature;
  late String weatherIcon;
  late String cityName;
  late String weatherImage;
  late String weatherDescription;
  late int feelsLike;
  late int humidity;

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        weatherIcon = 'Error';
        cityName = '';
        feelsLike = 0;
        humidity = 0;
        weatherDescription = 'Unable to get weather data';
        weatherImage = 'city_screen';
        return;
      }
      double temp = weatherData['main']['temp'];
      temperature = temp.toInt();
      int condition = weatherData['weather'][0]['id'];
      weatherIcon = weatherModel.getWeatherIcon(condition);
      cityName = weatherData['name'];
      weatherImage = weatherModel.getWeatherImage(condition);
      weatherDescription = weatherData['weather'][0]['description'];
      weatherDescription =
          weatherDescription[0].toUpperCase() + weatherDescription.substring(1);
      double feelslike = weatherData['main']['feels_like'];
      feelsLike = feelslike.toInt();
      humidity = weatherData['main']['humidity'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/$weatherImage.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          var weatherData =
                              await weatherModel.getLocationWeather();
                          updateUI(weatherData);
                        },
                        child: const Icon(
                          Icons.near_me,
                          size: 50.0,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          var typedName = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CityScreen()));
                          if (typedName != null) {
                            var weatherData =
                                await weatherModel.getCityWeather(typedName);
                            updateUI(weatherData);
                          }
                        },
                        child: const Icon(
                          size: 50.0,
                          Icons.location_city,
                          color: Colors.white,
                        ),
                      )
                    ]),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(children: [
                    Text(
                      '$temperature°C ',
                      style: const TextStyle(
                        fontSize: 75.0,
                      ),
                    ),
                    Text(
                      weatherIcon,
                      style: const TextStyle(
                        fontSize: 50.0,
                      ),
                    )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    '$cityName\n'
                    '$weatherDescription\n'
                    'Feels Like: $feelsLike°C\n'
                    'Humidity: $humidity',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
