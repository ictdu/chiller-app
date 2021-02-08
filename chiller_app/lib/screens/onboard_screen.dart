import 'package:chiller_app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentPage = 0;

List<Widget> _pages=[
  //page1 of the onboarding screen
  Column(
    children: [
      Expanded(child: Image.asset('images/address.png')),
      Text('Set your delivery location',
      style: kPageViewTextStyle,),
    ],
  ),
  //page2 of the onboarding screen
  Column(
    children: [
      Expanded(child: Image.asset('images/order.png')),
      Text('Order your food',
      style: kPageViewTextStyle,),
    ],
  ),
  //page3 of the onboarding screen
  Column(
    children: [
      Expanded(child: Image.asset('images/fooddelivery.png')),
      Text('Receive it at your doorstep!',
      style: kPageViewTextStyle,),
    ],
  ),
];

//for the dots
class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: _pages,
                onPageChanged: (index){
                setState(() {
                  _currentPage = index;
                });

                },
            ),
          ),
          SizedBox(height: 20,),
          DotsIndicator(
            dotsCount: _pages.length,
            position: _currentPage.toDouble(),
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              activeColor: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
