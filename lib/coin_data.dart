import 'dart:convert';
import 'constants.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  var price;

  Future getCoinData(String coinId, String currencyId) async {
    http.Response response = await http.get(
        '$kApiURl/currencies/ticker?key=$kApiKey&ids=$coinId&convert=$currencyId');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      price = double.parse(data[0]['price']);

      return price;
    } else {
      print(response.statusCode);

      throw 'Problem with the get request';
    }
  }
}
