
import 'package:barber/screens/add_shop.dart';
import 'package:flutter/material.dart';
import './shop_overview.dart';
import './slots.dart';
import 'package:geolocator/geolocator.dart';


class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {


  final List<Map<String, Object>> _pages = [
    {
      'page': ShopOverview(),
      'title' : 'Shops'
    },
    {
      'page': Slots(),
      'title' : 'My Slots'
    }
  ];
  var _selectedIndex = 0;

  void _selectScreen(index){
    setState(() {
      _selectedIndex = index;
    });
  }


    @override
  Widget build(BuildContext context) {
//    print("curr:"+_currentAddress);
    return Scaffold(
      appBar: AppBar(
        title: Text('Barber'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(AddShop.routeName),
          )
        ],
      ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectScreen,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text('Shops'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            title: Text('My Slots'),
          )
        ],
      ),
    );
  }
}
