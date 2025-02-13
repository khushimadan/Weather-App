import 'package:weather/services/location.dart';
import 'package:weather/services/networking.dart';

const apiKey = add_your_API_KEY;
const openWeatherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
        url: '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        url:
            '$openWeatherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getWeatherImage(int condition) {
    if (condition < 300) {
      return 'lightning';
    } else if (condition < 400) {
      return 'rain_cloud';
    } else if (condition < 600) {
      return 'rainy'; //tested
    } else if (condition < 700) {
      return 'snow';
    } else if (condition < 800) {
      return 'fog'; //tested
    } else if (condition == 800) {
      return 'sunny'; //tested
    } else if (condition <= 804) {
      return 'cloudy'; //tested
    } else {
      return 'city_screen';
    }
  }
}
