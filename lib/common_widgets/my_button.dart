import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Color btnColor;
  final Color textColor;
  final Widget child;
  final bool isLoading;
  final void Function() onBtnPressed;

  MyButton({this.btnColor, this.textColor, this.child, this.isLoading = false, this.onBtnPressed});

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      // alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
          width: double.infinity,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)
            ),
            elevation: 4,
            padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
            onPressed: widget.onBtnPressed,
            color: widget.btnColor,
            textColor: widget.textColor,
            child: widget.child,
          ),
        ),
        widget.isLoading == true ?
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: 0.2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              // color: Colors.white,
              child: Center(
                child: CircularProgressIndicator()
              ),
            ),
          ),
        )
        :
        SizedBox(width: 0, height: 0),
      ],
    );
  }
}