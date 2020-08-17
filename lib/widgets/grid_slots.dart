import '../provider/slots_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/shop.dart';
import './slots_dialog.dart';

class GridSlots extends StatefulWidget {
  final shopId;
  final index;

  GridSlots(this.shopId, this.index);

  @override
  _GridSlotsState createState() => _GridSlotsState();
}

class _GridSlotsState extends State<GridSlots> {
  bool booked = false;
  bool slotBookedInaDay = false;
  bool per = false;
  @override
  void initState() {
    Provider.of<SlotsProvider>(context, listen: false).fetchSlot();
    Provider.of<Shop>(context, listen: false).changeBookStatus(false);
    super.initState();
  }

  // @override
  // void dispose() {
  //   print('hey.............................');

  //   // Provider.of<Shop>(context, listen: false).dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final shopItem = Provider.of<Shop>(context);
    final slots = Provider.of<SlotsProvider>(context, listen: false);
    // final shop = shopItem.findById(widget.shopId);
    final slotItem = slots.items;

    slotItem.map((e) {
      if (e.creatorId == widget.shopId) {
        if (e.slotId == widget.shopId + widget.index.toString()) {
          if (e.isBooked == true) {
            booked = true;
            print('hey..............................');
            shopItem.changeBookStatus(true);
            // slotBookedInaDay = true;
          }
        }
      }
    }).toList();

    return shopItem.timing(widget.shopId, widget.index) == "12:00 - 12:30"
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTile(
              child: GridTileBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Center(child: Text('Break')),
              ),
            ))
        : GestureDetector(
            onTap: () {
              print("per$per");
              if (shopItem.isSlotBooked) {
                final snackbar = SnackBar(
                  content: Text('Can\'t book more than one slot in a day!'),
                  action: SnackBarAction(
                    label: 'Ok',
                    onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
                  ),
                );
                return Scaffold.of(context).showSnackBar(snackbar);
              } else {
                return showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => SlotsDialog(
                        widget.shopId,
                        shopItem.timing(widget.shopId, widget.index),
                        widget.index.toString())).then((value) {
                  print(value);
                  setState(() {
                    booked = value;
                    // slotBookedInaDay = value;
                    slots.fetchSlot();
                  });
                });
              }
            },
            child: Consumer<SlotsProvider>(
              builder: (ctx, slots, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GridTile(
                    child: GridTileBar(
                      backgroundColor: booked == true
                          ? Colors.green
                          : Theme.of(context).primaryColor,
                      title: Text(
                        shopItem.timing(widget.shopId, widget.index),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.5),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
