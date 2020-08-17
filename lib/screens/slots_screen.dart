import '../widgets/grid_slots.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/shop.dart';
import '../provider/slots_provider.dart' show SlotsProvider;

class SlotsScreen extends StatefulWidget {
  static const routeName = '/slots_screen';

  @override
  _SlotsScreenState createState() => _SlotsScreenState();
}

class _SlotsScreenState extends State<SlotsScreen> {
  var isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if(isInit){
      setState(() {
        isLoading = true;
      });
      Provider.of<SlotsProvider>(context, listen: false).fetchSlot().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<Shop>(context, listen: false);
    final slots = Provider.of<SlotsProvider>(context);
    final shopId = ModalRoute.of(context).settings.arguments as String;
    final shopItem = shop.item.firstWhere((shop) => shop.id == shopId);
    


    return Scaffold(
        appBar: AppBar(
          title: Text(shopItem.title),
        ),
        body: isLoading ? Center(child: CircularProgressIndicator(),): Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 250,
              child: Image.network(
                shopItem.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '---- Book Slots ----',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25,),
            Expanded(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 3 / 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, index) {
                      return GridSlots(shopId, index);
                      }, itemCount: shop.slotsCount(shopId),),
                ),
            ),

          ],
        ),
    );
  }
}
