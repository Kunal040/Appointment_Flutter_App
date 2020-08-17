import 'dart:developer';

import 'package:barber/provider/shop.dart';
import 'package:barber/provider/slots_provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class AddShop extends StatefulWidget {
  static const routeName = '/add-shop';

  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _locationFocus = FocusNode();
  final _imageFocus = FocusNode();
  final _imageController = TextEditingController();
  var _shopElements = ShopItem(
    id: null,
    title: '',
    location: '',
    imageUrl: '',
    shopOpenTime: null,
    shopCloseTime: null,
  );

  @override
  void dispose() {
    _locationFocus.dispose();
    _imageFocus.removeListener(_updateImage);
    _imageFocus.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _updateImage() {
    if (!_imageFocus.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final validate = _formKey.currentState.validate();
    if (!validate) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_shopElements.id == null) {
        await Provider.of<Shop>(context, listen: false).addShop(_shopElements);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
    catch (error) {
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
//    print(_shopElements);
//    final shop = Provider.of<Shop>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Shop Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          )
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),):Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
          TextFormField(
          decoration: InputDecoration(
            labelText: 'Title',
          ),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_locationFocus);
          },
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter required data";
              }
              return null;
            },
          onSaved: (value) {
            _shopElements = ShopItem(
              id: _shopElements.id,
              title: value,
              location: _shopElements.location,
              imageUrl: _shopElements.imageUrl,
              shopOpenTime: _shopElements.shopOpenTime,
              shopCloseTime: _shopElements.shopCloseTime,
            );
          },
        ),
        TextFormField(
            decoration: InputDecoration(
              labelText: 'Location',
            ),
            focusNode: _locationFocus,
            validator: (value) {
              if (value.isEmpty) {
                return "Please enter required data";
              }
              return null;
            },
            onSaved: (value){
      _shopElements = ShopItem(
      id: _shopElements.id,
      title: _shopElements.title,
      location: value,
      imageUrl: _shopElements.imageUrl,
      shopOpenTime: _shopElements.shopOpenTime,
      shopCloseTime: _shopElements.shopCloseTime,
      );
      },
      ),
      DateTimeField(
        format: DateFormat.Hm(),
        decoration: InputDecoration(
            labelText: 'Shop opening time'
        ),
        onShowPicker: (ctx, current_value) async {
          final time = await showTimePicker(context: ctx,
              initialTime: TimeOfDay.fromDateTime(
                  current_value ?? DateTime.now()));
          return DateTimeField.convert(time);
        },
        validator: (value) {
          if (value == null) {
            return "Please enter required data";
          }
          if ((value.minute != 30) && (value.minute != 0)) {
            return "Either select '00' or '30' in minutes. example: 9:00 or 9:30";
          }
          return null;
        },
        onSaved: (value) {
          _shopElements = ShopItem(
            id: _shopElements.id,
            title: _shopElements.title,
            location: _shopElements.location,
            imageUrl: _shopElements.imageUrl,
            shopOpenTime: TimeOfDay.fromDateTime(value),
            shopCloseTime: _shopElements.shopCloseTime,
          );
        },
      ),
      DateTimeField(
        format: DateFormat.Hm(),
        decoration: InputDecoration(
            labelText: 'Shop closing time'
        ),
        onShowPicker: (ctx, current_value) async {
          final time = await showTimePicker(context: ctx,
              initialTime: TimeOfDay.fromDateTime(
                  current_value ?? DateTime.now()));
          return DateTimeField.convert(time);
        },
        validator: (value) {
          if (value == null) {
            return "Please enter required data";
          }
          if ((value.minute != 30) && (value.minute != 0)) {
            return "Either select '00' or '30' in minutes. example: 9:00 or 9:30";
          }
          return null;
        },
        onSaved: (value) {
          _shopElements = ShopItem(
            id: _shopElements.id,
            title: _shopElements.title,
            location: _shopElements.location,
            imageUrl: _shopElements.imageUrl,
            shopOpenTime: _shopElements.shopOpenTime,
            shopCloseTime: TimeOfDay.fromDateTime(value),
          );
        },
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: _imageController.text.isEmpty ? Text('Enter Url') : Image
                .network(_imageController.text, fit: BoxFit.cover,),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'ImageUrl'
              ),
              controller: _imageController,
              onFieldSubmitted: (_) => _updateImage(),
              validator: (value){
                if(value.isEmpty){
                  return "Please enter required data";
                }
                return null;
              },
              onSaved: (value) {
                _shopElements = ShopItem(
                  id: _shopElements.id,
                  title: _shopElements.title,
                  location: _shopElements.location,
                  imageUrl: value,
                  shopOpenTime: _shopElements.shopOpenTime,
                  shopCloseTime: _shopElements.shopCloseTime,
                );
              },
            ),
          )
        ],
      )
      ],
    ),)
    ,
    )
    ,

    );
  }
}
