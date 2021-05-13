import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class ShopItem with ChangeNotifier {
  final String id;
  final String title;
  final String location;
  final String imageUrl;
  final TimeOfDay shopOpenTime;
  final TimeOfDay shopCloseTime;

  ShopItem({
    @required this.id,
    @required this.title,
    @required this.location,
    @required this.imageUrl,
    @required this.shopOpenTime,
    @required this.shopCloseTime,
  });
}

class Shop with ChangeNotifier {
  List<ShopItem> _item = [
 //example
//    ShopItem(
//      id: 'b1',
//      title: 'Barber 1',
//      location: 'Indore',
//      imageUrl: 'https://www.thetrendspotter.net/wp-content/uploads/2020/03/Best-Barbershops-in-Perth.jpg',
//      shopOpenTime: TimeOfDay(hour: 09, minute: 00),
//      shopCloseTime: TimeOfDay(hour: 21, minute: 30),
//    ),
  ];

  List<ShopItem> get item {
    return [..._item];
  }

  bool isSlotBooked = false;

  bool changeBookStatus(bool status) {
    isSlotBooked = status;
    return isSlotBooked;
  }

  int slotsCount(String shopId) {
    final shopItem = _item.firstWhere((shop) => shopId == shop.id);
    var closeHour = shopItem.shopCloseTime.hour;
    var closeMinute = shopItem.shopCloseTime.minute;
    var openHour = shopItem.shopOpenTime.hour;
    var openMinute = shopItem.shopOpenTime.minute;
    if (openMinute - closeMinute < 0) {
      return 2 * (closeHour - openHour) + 1;
    } else if (openMinute - closeMinute == 0) {
      return 2 * (closeHour - openHour);
    } else if (openMinute - closeMinute > 0) {
      return 2 * (closeHour - openHour) - 1;
    }
  }

  String timing(String shopId, int index) {
    final shopItem = _item.firstWhere((shop) => shop.id == shopId);
    List<String> _list = [];
    var closeHour = shopItem.shopCloseTime.hour;
    var closeMinute = shopItem.shopCloseTime.minute;
    var openHour = shopItem.shopOpenTime.hour;
    var openMinute = shopItem.shopOpenTime.minute;
    var hour = openHour;
    var minutes = openMinute;
    while (hour <= closeHour) {
      _list.add("${hour}:${minutes}");
      minutes += 30;
      if (minutes == 60) {
        hour += 1;
        minutes = 0;
      }
    }
    return "${_list[index].replaceAll(':0', ':00')} - ${_list[index + 1].replaceAll(':0', ':00')}";
  }

  ShopItem findById(String id) {
    return _item.firstWhere((item) => item.id == id);
  }


  Future<void> addShop(ShopItem shopItem) async {
    final url = 'https://baber-slot-booking.firebaseio.com/shops.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': shopItem.title,
            'location': shopItem.location,
            'imageUrl': shopItem.imageUrl,
            'shopOpenTime': shopItem.shopOpenTime.hour.toString() +
                ':' +
                shopItem.shopOpenTime.minute.toString(),
            'shopCloseTime': shopItem.shopCloseTime.hour.toString() +
                ':' +
                shopItem.shopCloseTime.minute.toString(),
          }));
      _item.add(ShopItem(
        id: json.decode(response.body)['name'],
        title: shopItem.title,
        location: shopItem.location,
        imageUrl: shopItem.imageUrl,
        shopOpenTime: shopItem.shopOpenTime,
        shopCloseTime: shopItem.shopCloseTime,
      ));
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> fetch() async {
    final url = 'https://baber-slot-booking.firebaseio.com/shops.json';
    try {
      final response = await http.get(url);
      final List<ShopItem> loadedShop = [];
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((shopId, shopVal) {
        loadedShop.add(ShopItem(
          id: shopId,
          title: shopVal['title'],
          location: shopVal['location'],
          imageUrl: shopVal['imageUrl'],
          shopOpenTime: TimeOfDay(
              hour: int.parse(shopVal['shopOpenTime'].split(":")[0]),
              minute: int.parse(shopVal['shopOpenTime'].split(":")[1])),
          shopCloseTime: TimeOfDay(
              hour: int.parse(shopVal['shopCloseTime'].split(":")[0]),
              minute: int.parse(shopVal['shopCloseTime'].split(":")[1])),
        ));
      });
      _item = loadedShop;
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
