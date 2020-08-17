import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SlotsItem with ChangeNotifier {
  final String slotId;
  final String creatorId;
  final String timing;
  bool isBooked;

  SlotsItem(
      {@required this.slotId,
      @required this.creatorId,
      @required this.timing,
//    @required this.location,
      this.isBooked});
}

class SlotsProvider with ChangeNotifier {
  List<SlotsItem> _item = [];

  List<SlotsItem> get items {
    return [..._item];
  }

  Future<void> bookSlot(String id, String index, String timing,
      {bool isBooked = false}) async {
    final url = 'https://baber-slot-booking.firebaseio.com/slots.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'slotId': id + index,
            'creatorId': id,
            'isBooked': isBooked,
            'timings': timing
          }));
      _item.add(SlotsItem(
          slotId: id + index,
          creatorId: json.decode(response.body)['name'],
          timing: timing,
          isBooked: isBooked));
    } catch (error) {
      throw error;
    }

    notifyListeners();
  }

  Future<void> fetchSlot() async {
    final url = 'https://baber-slot-booking.firebaseio.com/slots.json';
    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        print('response code error: ${response.statusCode}');
      }

      print(json.decode(response.body));

      List<SlotsItem> _loadedSlots = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        print('getting null');
        _item = [];
        _loadedSlots = [];
        return;
      }
      extractedData.forEach((key, value) {
        _loadedSlots.add(SlotsItem(
            slotId: value['slotId'],
            creatorId: value['creatorId'],
            timing: value['timings'],
            isBooked: value['isBooked'] == null ? false : value['isBooked']));
      });
      _item = _loadedSlots;
    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> removeSlot(String id) async {
    final response = _item.firstWhere((element) => element.slotId == id);
    String _key;

    var url = 'https://baber-slot-booking.firebaseio.com/slots.json';
    try {
      final res = await http.get(url);
      if (res.body.isEmpty) {
        _item.remove(response.slotId);
        return;
      }
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if (extractedData == null) {
        print('null.......');
      }
      extractedData.forEach((key, value) {
        if (value['slotId'] == response.slotId) {
          _key = key;
        }
      });
      url = 'https://baber-slot-booking.firebaseio.com/slots/$_key.json';
      final delete = await http.delete(url);
      if (delete.statusCode >= 400) {
        print('response code error: ${delete.statusCode}');
        throw HttpException;
      }
      _item.remove(response.slotId);
    } catch (error) {
      print(error);
    }
    notifyListeners();
  }

  Future<void> removeBookSlot(String id, String index) async {
    final extractedItem =
        _item.firstWhere((element) => element.slotId == id + index);
    var newId = extractedItem.creatorId;
    final url = 'https://baber-slot-booking.firebaseio.com/slots/$newId.json';
    try {
      final delete = await http.delete(url);
      if (delete.statusCode >= 400) {
        print('response code error: ${delete.statusCode}');
      }
      _item.removeWhere((element) => element.slotId == id + index);
    } catch (error) {
      print(error);
      throw error;
    }

    notifyListeners();
  }
}
