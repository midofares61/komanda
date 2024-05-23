import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../login/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<String> list = ["عميل", "فني"];
  String? dropdownValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
              ),
              Image(
                image: AssetImage("assets/images/icon.png"),
                width: 150,
                height: 150,
              ),
              Text(
                "كوماندا",
                style: TextStyle(
                    color: defaultColor,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "نوع التسجيل",
                      style: TextStyle(
                          fontSize: 30,
                          color: defaultColor,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: defaultColor),
                          borderRadius: BorderRadius.circular(20)),
                      child: DropdownButton<String>(
                        hint: const Text("-- اختر من الخيارات المتاحة --"),
                        underline: Container(),
                        value: dropdownValue,
                        isExpanded: true,
                        style:
                            const TextStyle(color: defaultColor, fontSize: 25),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    defaultButton(
                        navigate: () {
                          navigateTo(context: context, widget: LoginScreen());
                        },
                        text: "تسجيل دخول",
                        color: Colors.white,
                        background: defaultColor),
                    SizedBox(
                      height: 20,
                    ),
                    defaultButton(
                        navigate: () {},
                        text: "انشاء حساب",
                        color: defaultColor,
                        background: Colors.white),
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: defaultColor,
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("طريقه اخري لتسجيل"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {},
                          child: SvgPicture.asset(
                            "assets/images/facebook.svg",
                            width: 30,
                            height: 30,
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: SvgPicture.asset(
                            "assets/images/Google.svg",
                            width: 30,
                            height: 30,
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {},
                          child: SvgPicture.asset(
                            "assets/images/Github.svg",
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
