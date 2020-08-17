import 'package:barber/provider/shop.dart';
import 'package:barber/widgets/booked_slots.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/slots_provider.dart';

class Slots extends StatefulWidget {
  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  bool _isInit = true;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _loading = true;
      });
      Provider.of<SlotsProvider>(context, listen: false).fetchSlot().then((_) {
        setState(() {
          _loading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  String getShopTitle(SlotsProvider slots, int index, [bool isTiming = false]) {
    final shop = Provider.of<Shop>(context);
    if (isTiming) {
      final timing = slots.items[index].timing;
      return timing;
    }
    final id = slots.items[index].creatorId;
    final response = shop.item.firstWhere((element) => element.id == id);

    return response.title;
  }

  @override
  Widget build(BuildContext context) {
    final slots = Provider.of<SlotsProvider>(context, listen: false);

    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              children: <Widget>[
                Text(
                  'Current Bookings',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          key: ValueKey(slots.items[index].slotId),
                          background: Container(
                            color: Theme.of(context).errorColor,
                            child: Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.white,
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            padding: EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                          ),
                          onDismissed: (value) {
                            slots.removeSlot(slots.items[index].slotId);
                          },
                          confirmDismiss: (value) {
                            return showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: Text("Do you want to delete"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Yes'),
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                        ),
                                        FlatButton(
                                            child: Text('No'),
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(false)),
                                      ],
                                    ));
                          },
                          child: Card(
                            elevation: 8,
                            margin: EdgeInsets.all(5),
                            child: ListTile(
                              title: Text(getShopTitle(slots, index)),
                              subtitle: Text(getShopTitle(slots, index, true)),
                            ),
                          ),
                        );
                      },
                      itemCount: slots.items.length,
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
