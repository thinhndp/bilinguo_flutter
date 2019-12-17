import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  renderWidgetRepeatedLy(widgetList, repeatCount) {
    List<Widget> newList = [];
    for (int i = 0; i < repeatCount; i++) {
      newList = newList + widgetList;
    }
    return newList;
  }

  renderShopRoof() {
    double roofHeight = 55.0;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
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