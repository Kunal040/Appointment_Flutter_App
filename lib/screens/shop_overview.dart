import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/shop.dart' show Shop;


import '../widgets/shop_item.dart';
import 'package:geolocator/geolocator.dart';


class ShopOverview extends StatefulWidget {



  @override
  _ShopOverviewState createState() => _ShopOverviewState();
}

class _ShopOverviewState extends State<ShopOverview> {
  static String _currentAddress = "";
  var _isInit = true;
  var _isLoading = false;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;

  Future _checkLocation() async {
    if (!(await geolocator.isLocationServiceEnabled())) {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text('Can\'t get location'),
              content: const Text('Please enable the location'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _checkLocation();
                  },
                )
              ],
            );
          });
    }
    else{
        _getCurrentLocation();
    }
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<Shop>(context).fetch().then((_){
        setState(() {
          _isLoading = false;
        });
      }).catchError((error){
        print(error.toString());
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Error occured while loading... Please try again later!'),));
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLocation();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality.toString()}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<Shop>(context);
    final shopItem = _currentAddress != "" ? shop.item.where((val) => val.location.toLowerCase() == _currentAddress.toString().toLowerCase()).toList(): shop.item;
    return _isLoading ? Center(child: CircularProgressIndicator(),): Card(
      margin: EdgeInsets.all(10),
      child: ListView.builder(itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: shopItem[index], child: ShopItem(),);
      }, itemCount: shopItem.length,),
    );
  }

}


