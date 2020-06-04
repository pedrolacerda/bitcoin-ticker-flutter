import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCoin = 'LTC';
  String selectedCurrency = 'USD';
  String coinValueInCurrency = '?';

  @override
  void initState() {
    super.initState();

    getData();
  }

  void getData() async {
    try {
      double data =
          await CoinData().getCoinData(selectedCoin, selectedCurrency);

      setState(() {
        coinValueInCurrency = data.toStringAsFixed(2);
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

  DropdownButton<String> androidDropDownCoins() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String coin in cryptoList) {
      print(coin);

      var newItem = DropdownMenuItem(
        child: Text(coin),
        value: coin,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCoin = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iIOSPicker() {
    List<Text> pickerItems = [];

    for (String coin in cryptoList) {
      pickerItems.add(Text(coin));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCoin = cryptoList[selectedIndex];
        getData();
      },
      children: pickerItems,
    );
  }

  CupertinoPicker iIOSPickerCoins() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        print('selectedCurrency: $selectedCurrency');
        getData();
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    return Platform.isIOS ? iIOSPicker() : androidDropDown();
  }

  Widget getCoinPicker() {
    return Platform.isIOS ? iIOSPickerCoins() : androidDropDownCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 $selectedCoin = $coinValueInCurrency $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getCoinPicker(),
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
