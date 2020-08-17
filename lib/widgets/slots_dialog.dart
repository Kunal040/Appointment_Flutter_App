import '../provider/shop.dart';

import '../provider/slots_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SlotsDialog extends StatelessWidget {
  final shopId;
  final timings;
  final index;
  SlotsDialog(this.shopId, this.timings, this.index);

  @override
  Widget build(BuildContext context) {
    final slots = Provider.of<SlotsProvider>(context, listen: false);
    final shop = Provider.of<Shop>(context);
    final shopItem = shop.item.firstWhere((item) => item.id == shopId);
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Do you want to book ${timings} slot?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BookButton(slots: slots, shopId: shopId, index: index, timing: timings,),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
                    ),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
//                      slots.removeBookSlot(shopId, index);
//                    slots.bookSlot(shopId, index, shopItem.title, shopItem.location, isBooked: false);
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookButton extends StatefulWidget {
  final SlotsProvider slots;
  final shopId;
  final index;
  final timing;

  const BookButton({
    Key key,
    @required this.slots,
    @required this.shopId,
    @required this.index,
    @required this.timing,
  }) : super(key: key);

  @override
  _BookButtonState createState() => _BookButtonState();
}

class _BookButtonState extends State<BookButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
        ),
        color: Theme.of(context).primaryColor,
        child: _isLoading
            ? CircularProgressIndicator()
            : Text(
                'Book',
                style: TextStyle(color: Colors.white),
              ),
        onPressed: _isLoading
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await widget.slots
                    .bookSlot(widget.shopId, widget.index, widget.timing, isBooked: true)
                    .then((_) => Navigator.of(context).pop(true));
                setState(() {
                  _isLoading = false;
                });
                // Navigator.of(context).pop(true);
              });
  }
}
