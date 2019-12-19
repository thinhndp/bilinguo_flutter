import 'package:flutter/material.dart';
import 'mock-data.dart';

class ShopScreen extends StatelessWidget {
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
        children: renderWidgetRepeatedLy(
            <Widget>[
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned.fill(
                      bottom: -1 * roofHeight,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xffd20d1b),
                            shape: BoxShape.circle
                        ),
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
                            color: Color(0xffae0002),
                            shape: BoxShape.circle
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xffd6081a),
                    ),
                  ],
                ),
              ),
            ],
            6
        ),
      ),
    );
  }
  
  renderItemList(items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map<Widget>((item) => (
        Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
         child: Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Flexible(
               flex: 1,
               child: Container(
                 padding: EdgeInsets.fromLTRB(10, 15, 0, 20),
                 child: Image.asset('assets/' + item.imgUrl),
               ),
             ),
             Flexible(
               flex: 2,
               child: Container(
                 padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Text(
                         item.name,
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             fontSize: 18
                         )
                     ),
                     SizedBox(height: 10),
                     Text(
                         item.description,
                         style: TextStyle(
                             fontWeight: FontWeight.w500,
                             fontSize: 15,
                             color: Colors.black54,
                           height: 1.5,
                         )
                     ),
                     SizedBox(height: 10),
                     Row(
                       children: <Widget>[
                         Image.asset('assets/icons/lingot.png', width: 26),
                         SizedBox(width: 3),
                         Text(
                             item.price.toString(),
                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xffff4b4b))
                         )
                       ],
                     )
                   ],
                 ),
               )
             )
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
            boxShadow: [BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
            )],
          ),
        )
      )).toList(),
    );
  }

  renderItemGroup(itemGroup) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(itemGroup.name, style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold )),
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
          Container(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 55, 20, 30),
              shrinkWrap: true,
              children: <Widget>[
                renderItemGroup(powerUps),
                renderItemGroup(loremIpsum),
              ],
            ),
          ),
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              renderShopRoof(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Cửa hàng',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    )
                  ),
                  SizedBox(width: 15),
                  Image.asset('assets/icons/lingot.png', height: 24,),
                  SizedBox(width: 5),
                  Text(
                      '68',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      )
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}