import 'package:smarty/models/locationModel.dart';
import 'package:smarty/models/networkModel.dart';

const kAPIKey = 'd6990a93802ef960b648309d2769ec32';
const kURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future weatherDataCity(String cityName) async {
    Location loc = Location();
    await loc.getCurrentLocation();
    Network network =
        Network(url: '$kURL?q=$cityName&appid=$kAPIKey&units=metric');

    return await network.getData();
  }

//future weatherdata
  Future weatherData() async {
    Location loc = Location();
    await loc.getCurrentLocation();
    Network network = Network(
        url:
            '$kURL?lat=${loc.position.latitude}&lon=${loc.position.longitude}&appid=$kAPIKey&units=metric');

    return await network.getData();
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '๐ฉ';
    } else if (condition < 400) {
      return '๐ง';
    } else if (condition < 600) {
      return 'โ';
    } else if (condition < 700) {
      return 'โ';
    } else if (condition < 800) {
      return '๐ซ';
    } else if (condition == 800) {
      return 'โ';
    } else if (condition <= 804) {
      return 'โ';
    } else {
      return '๐คทโ';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s ๐ฆ time';
    } else if (temp > 20) {
      return 'Time for shorts and ๐';
    } else if (temp < 10) {
      return 'You\'ll need ๐งฃ and ๐งค';
    } else {
      return 'Bring a ๐งฅ just in case';
    }
  }
}
