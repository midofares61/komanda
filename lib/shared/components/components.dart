import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';


import '../styles/colors.dart';

Widget buildItems(Map<String, dynamic> data, int index, bool isDesktop, context,
        widget, color) =>
    InkWell(
      onTap: () {
        navigateTo(context: context, widget: widget);
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
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
                data["name"],
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
              data["descreption"],
              style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 20 : 13,
              ),
            ),
          )
        ]),
      ).animate().slideX(delay: (index*100).ms),
    );

void navigateTo({required context, required widget}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateToFinish({required context, required widget}) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => widget), (route) {
    return false;
  });
}

Widget defaultButton({
  required String text,
  required Color color,
  required Color background,
  required Function() navigate,
}) =>
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: defaultColor)),
      child: TextButton(
        onPressed: navigate,
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: 25),
        ),
      ),
    );
