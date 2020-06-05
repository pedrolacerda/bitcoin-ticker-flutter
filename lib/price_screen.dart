import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'currency_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  String btcValueInCurrency = '?';
  String ethValueInCurrency = '?';
  String ltcValueInCurrency = '?';

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    try {
      double dataBTC = await CoinData().getCoinData('BTC', selectedCurrency);
      double dataETH = await CoinData().getCoinData('ETH', selectedCurrency);
      double dataLTC = await CoinData().getCoinData('LTC', selectedCurrency);

      setState(() {
        btcValueInCurrency = dataBTC.toStringAsFixed(2);
        ethValueInCurrency = dataETH.toStringAsFixed(2);
        ltcValueInCurrency = dataLTC.toStringAsFixed(2);
      });
    } catch (e) {
      print(e);
    }
  }

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iIOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    return Platform.isIOS ? iIOSPicker() : androidDropDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CurrencyCard(
                    selectedCoin: 'BTC',
                    coinValueInCurrency: btcValueInCurrency,
                    selectedCurrency: selectedCurrency),
                CurrencyCard(
                    selectedCoin: 'ETH',
                    coinValueInCurrency: ethValueInCurrency,
                    selectedCurrency: selectedCurrency),
                CurrencyCard(
                    selectedCoin: 'LTC',
                    coinValueInCurrency: ltcValueInCurrency,
                    selectedCurrency: selectedCurrency),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
