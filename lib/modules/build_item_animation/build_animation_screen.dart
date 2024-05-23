import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../shared/components/components.dart';
import '../product/product_screen.dart';

class buildItemsAnimation extends StatefulWidget {
  final Color color;
  final String name;
  final List<dynamic> data;
  const buildItemsAnimation({
    super.key,
    required this.color,
    required this.name,
    required this.data,
  });
  @override
  State<buildItemsAnimation> createState() => _buildItemsAnimationState();
}

class _buildItemsAnimationState extends State<buildItemsAnimation> {
  double screenWidth=0 ;
  double screenHeight=0;
  bool startAnimation = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        startAnimation = true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
      final isDesktop = MediaQuery.of(context).size.width >= 500;
      return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) =>  Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                navigateTo(context: context, widget: ProductScreen(
                  name: widget.data[index]["name"],
                  list: widget.data[index]["id"],
                  btn: widget.name == "خدمات مهنيه"
                      ? "عرض الاشخاص"
                      : "عرض المتاجر",
                ));
              },
              child: AnimatedContainer(
                padding: EdgeInsets.all(15),
                curve: Curves.easeInOut,
                width: screenWidth,
                transform: Matrix4.translationValues(
                    0, startAnimation ? 0 : (screenHeight), 0),
                duration: Duration(milliseconds: 400 + (index * 200)),
                decoration: BoxDecoration(
                  color: widget.color,
                  boxShadow: [
                    BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 5)
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                      bottomRight: Radius.circular(70),
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/air-conditioner 1.svg"),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.data[index]["name"],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 25 : 20,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(25),
                    child: Text(
                      widget.data[index]["descreption"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isDesktop ? 20 : 13,
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ),separatorBuilder: (context, index) =>
          SizedBox(height: 20),
          itemCount: widget.data.length);
  }
}
