import 'package:flutter/material.dart';
import './models/ItemGroup.dart';
import './models/Item.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:bilinguo_flutter/models/AppState.dart';
import './models/User.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'mock-data.dart';

class ShopWidget extends StatefulWidget {
  ShopWidget({ this.viewModel });
  final ViewModel viewModel;

  @override
  _ShopWidgetState createState() => _ShopWidgetState();
}

class _ShopWidgetState extends State<ShopWidget> {
  List<ItemGroup> _itemGroups;
  User _currentUser;
  bool _isBuyingItem = false;

  @override
  void initState() {
    _currentUser = widget.viewModel.currentUser;
    _isBuyingItem = false;
    ItemGroup.fetchItemGroups().then((itemGroups) {
      setState(() {
        _itemGroups = itemGroups;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _handleBuyItem(item) {
    if (_currentUser == null || _currentUser.fortune < item.price) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Có đủ tiền đâu mà mua'),
        backgroundColor: Color(0xffff4444),
      ));
      return;
    }
    setState(() {
      _isBuyingItem = true;
    });
    Item.buyItem(widget.viewModel, item)
    .then((updatedUser) {
      setState(() {
        _currentUser = updatedUser;
        _isBuyingItem = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Mua vật phẩm thành công!'),
        backgroundColor: Color(0xff00C851),
      ));
    })
    .catchError((err) {
      print(err);
    });
  }

  void _showDialog(item) {
    Scaffold.of(context).hideCurrentSnackBar();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "Yo wise choice right there mah nig",
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          // content: Text('Bạn có muốn mua "' + item.name + '" với giá ' + item.price.toString() + ' lingots?'),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Image.network("https://hotemoji.com/images/dl/h/put-litter-in-its-place-symbol-emoji-by-twitter.png"),
                // SizedBox(height: 6.0,),
                Image.asset('assets/right-choice.png', width: 100.0,),
                SizedBox(height: 16.0,),
                RichText(
                  text: TextSpan(
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontFamily: 'Quicksand',
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Bạn có muốn mua '),
                      TextSpan(
                          text: item.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Color(0xff1CB0F6))),
                      TextSpan(text: ' với giá '),
                      TextSpan(
                          text: item.price.toString() + ' Lingots',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Color(0xffff4b4b))),
                      TextSpan(text: '?'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text(
                "Đéo.".toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text(
                "Mua cả họ m".toUpperCase(),
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                // TODO: Implement this shit
                Navigator.of(context).pop();
                _handleBuyItem(item);
              },
            ),
          ],
        );
      },
    );
  }

  renderWidgetRepeatedLy(widgetList, repeatCount) {
    List<Widget> newList = [];
    for (int i = 0; i < repeatCount; i++) {
      newList = newList + widgetList;
    }
    return newList;
  }

  renderShopRoof() {
    double roofHeight = 57.0;
    return SizedBox(
      height: roofHeight,
      child: Row(
        children: renderWidgetRepeatedLy(<Widget>[
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned.fill(
                  bottom: -1 * roofHeight,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffd20d1b), shape: BoxShape.circle),
                  ),
                ),
                Container(
                  color: Color(0xffe41622),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned.fill(
                  bottom: -1 * roofHeight,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffae0002), shape: BoxShape.circle),
                  ),
                ),
                Container(
                  color: Color(0xffd6081a),
                ),
              ],
            ),
          ),
        ], 6),
      ),
    );
  }

  renderItemList(items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map<Widget>((item) => (InkWell(
              onTap: () {
                _showDialog(item);
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 15, 0, 20),
                        child: Image.network(item.imgUrl),
                        // child: CachedNetworkImage(
                        //   placeholder: (context, url) => CircularProgressIndicator(),
                        //   imageUrl: 'https://picsum.photos/250?image=9',
                        // ),
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(item.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              SizedBox(height: 10),
                              Text(item.description,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Colors.black54,
                                    height: 1.5,
                                  )),
                              SizedBox(height: 10),
                              //  RaisedButton(
                              //    onPressed: () {},
                              //    color: Colors.white,
                              //    child: Row(
                              //     children: <Widget>[
                              //       Image.asset('assets/icons/lingot.png', width: 26),
                              //       SizedBox(width: 3),
                              //       Text(
                              //           item.price.toString(),
                              //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffff4b4b))
                              //       )
                              //     ],
                              //   )
                              //  ),
                              Row(
                                children: <Widget>[
                                  Image.asset('assets/icons/lingot.png',
                                      width: 26),
                                  SizedBox(width: 3),
                                  Text(item.price.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffff4b4b)))
                                ],
                              )
                            ],
                          ),
                        ))
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    style: BorderStyle.none,
                    //              width: 3,
                    //              style: BorderStyle.solid
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                    )
                  ],
                ),
              ))))
          .toList(),
    );
  }

  renderItemGroup(itemGroup) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(itemGroup.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          renderItemList(itemGroup.items)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          (_itemGroups != null)
              ? Container(
                  child: ListView(
                      padding: EdgeInsets.fromLTRB(20, 55, 20, 30),
                      shrinkWrap: true,
                      children: <Widget>[
                        ..._itemGroups
                            .map<Widget>(
                                (itemGroup) => (renderItemGroup(itemGroup)))
                            .toList(),
                        // renderItemGroup(powerUps),
                        // renderItemGroup(loremIpsum),
                      ]),
                )
              : Container(
                  // height: double.infinity,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[CircularProgressIndicator()],
                  ),
                ),
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              renderShopRoof(),
              Container(
                height: 57,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Cửa hàng",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/lingot.png',
                              height: 24,
                            ),
                            SizedBox(width: 5),
                            Text((_currentUser != null) ? _currentUser.fortune.toString() : '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
          if (_isBuyingItem) (
            Stack(
              children: <Widget>[
                Opacity(
                  opacity: 0.6,
                  child: ModalBarrier(dismissible: false, color: Colors.white),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return ShopWidget();
    return StoreConnector(
      converter: (Store<AppState> store) => ViewModel.create(store),
      builder: (context, ViewModel viewModel) => ShopWidget(viewModel: viewModel)
    );
  }
}
