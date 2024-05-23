import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../models/notification_model.dart';
import '../../shared/locale/db.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    CubitApp.get(context).profilModel==null?CubitApp.get(context).getProfile(id: CacheHelper.getData(key: "UserId")):null;
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: Scaffold(
                  body: ConditionalBuilder(
                      condition: cubit.profilModel != null,
                      builder: (context) => SingleChildScrollView(
                            child: Padding(
                              padding: isDesktop
                                  ? const EdgeInsets.all(40.0)
                                  : const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                          "assets/images/person.png",
                                        ),
                                        width: isDesktop ? 150 : 120,
                                        height: isDesktop ? 150 : 120,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${cubit.profilModel!.name}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: isDesktop ? 35 : 25,
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${cubit.profilModel!.email}",
                                              textWidthBasis:
                                                  TextWidthBasis.parent,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: cubit.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize:
                                                      isDesktop ? 20 : 17),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: isDesktop ? 30 : 20,
                                  ),
                                  InkWell(
                                    onTap: ()  {
                                      Fluttertoast.showToast(
                                          msg: "ستتوفر هذه الميزة قريبا",
                                          gravity: ToastGravity.BOTTOM,
                                          toastLength: Toast.LENGTH_LONG,
                                          backgroundColor: Colors.green,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 15),
                                      decoration: BoxDecoration(
                                          color: cubit.isDark
                                              ? darkColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 5),
                                          ]),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.notifications,
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "اعدادات الاشعارات",
                                                style: TextStyle(
                                                  fontSize: isDesktop ? 22 : 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: cubit.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: cubit.isDark
                                                ? Colors.white
                                                : Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: isDesktop ? 30 : 20,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      Fluttertoast.showToast(
                                          msg: "ستتوفر هذه الميزة قريبا",
                                          gravity: ToastGravity.BOTTOM,
                                          toastLength: Toast.LENGTH_LONG,
                                          backgroundColor: Colors.green,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 15),
                                      decoration: BoxDecoration(
                                          color: cubit.isDark
                                              ? darkColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 5),
                                          ]),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.email,
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "تغير البريد الالكتروني",
                                                style: TextStyle(
                                                  fontSize: isDesktop ? 22 : 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: cubit.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: cubit.isDark
                                                ? Colors.white
                                                : Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: isDesktop ? 30 : 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                          msg: "ستتوفر هذه الميزة قريبا",
                                          gravity: ToastGravity.BOTTOM,
                                          toastLength: Toast.LENGTH_LONG,
                                          backgroundColor: Colors.green,
                                          timeInSecForIosWeb: 1,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 15),
                                      decoration: BoxDecoration(
                                          color: cubit.isDark
                                              ? darkColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 5),
                                          ]),
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.lock,
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "تغير كلمه السر",
                                                style: TextStyle(
                                                  fontSize: isDesktop ? 22 : 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: cubit.isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: cubit.isDark
                                                ? Colors.white
                                                : Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: isDesktop ? 30 : 20,
                                  ),
                                  Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 15),
                                      decoration: BoxDecoration(
                                          color: cubit.isDark
                                              ? darkColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 5),
                                          ]),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.brightness_5_sharp,
                                                    color: cubit.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "المظهر",
                                                    style: TextStyle(
                                                      fontSize:
                                                          isDesktop ? 22 : 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: cubit.isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Switch(
                                                  activeColor: defaultColor,
                                                  value: cubit.isDark,
                                                  onChanged: (value) {
                                                    cubit.changeMode(
                                                        value: value);
                                                  })
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                      fallback: (context) =>
                          Center(child: SpinKitThreeBounce(
                            color: defaultColor,
                            size: 30,
                          )))),
            ),
          );
        });
  }
}
