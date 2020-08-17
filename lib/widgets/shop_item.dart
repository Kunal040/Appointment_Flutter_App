import '../screens/slots_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/shop.dart' as si;

class ShopItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<si.ShopItem>(context);
    return InkWell(
      onTap: () {
        print('mainShop${shop.id}');
        Navigator.of(context)
            .pushNamed(SlotsScreen.routeName, arguments: shop.id);
      },
      splashColor: Theme.of(context).accentColor,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: ListTile(
          title: Text(shop.title),
          subtitle: Text(shop.location),
          leading: CircleAvatar(
            child: Text('Shop'),
          ),
        ),
      ),
    );
  }
}
