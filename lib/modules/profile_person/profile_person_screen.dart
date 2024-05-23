import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';
import '../chat/chat_screen.dart';
import '../profile_image/profile_image.dart';

class ProfilePersonScreen extends StatelessWidget {
  final Map list;
  ProfilePersonScreen({super.key, required this.list});

  List<Map> data = [
    {
      "name": "كهربائي",
      "image": "assets/images/profile.png",
    },
    {
      "name": "نجار",
      "image": "assets/images/profile.png",
    },
    {
      "name": "سباك ",
      "image": "assets/images/profile.png",
    },
    {
      "name": "عامل  بلاط",
      "image": "assets/images/profile.png",
    },
    {
      "name": "نقاش",
      "image": "assets/images/profile.png",
    },
    {
      "name": "عمله نظافه",
      "image": "assets/images/profile.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: isDesktop
                        ? const EdgeInsets.all(40.0)
                        : const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(100)),
                              clipBehavior: Clip.antiAlias,
                              child: Image.memory(
                                base64Decode(list["img"]),
                                width: 100,
                                height: 100,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${list["name"]}",
                            style: TextStyle(
                                color:
                                    cubit.isDark ? Colors.white : defaultColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int n = 0; n < 5 - list["stars"]; n++)
                                Icon(Icons.star, color: Colors.grey),
                              for (int n = 0; n < list["stars"]; n++)
                                Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 255, 217, 0),
                                ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  navigateTo(
                                      context: context,
                                      widget: ChatScreen(
                                        id: list["id"],
                                        sender:
                                            CacheHelper.getData(key: "UserId"),
                                        name: list["name"],
                                        image: list["img"],
                                      ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/messenger.svg",
                                        width: 20,
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "رسلني",
                                        style: TextStyle(
                                            color: defaultColor, fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: cubit.isDark ? darkColor : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey, blurRadius: 5),
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "نبذة عني : ",
                                  style: TextStyle(
                                      color: cubit.isDark
                                          ? Colors.white
                                          : defaultColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Text(
                                    "أسعى دائمًا لتحسين وتطوير مهاراتي ومعرفتي في مجالي لتقديم أفضل الخدمات للعملاء. بفضل مرونة العمل كعامل حر، أستمتع بالقدرة على تكوين شراكات مع مختلف العملاء والمشاريع.أقدم خدماتي كعامل حر بروح إبداعية واهتمام شديد بتحقيق أهداف العملاء وتلبية توقعاتهم.",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: cubit.isDark
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            decoration: BoxDecoration(
                                color: cubit.isDark ? darkColor : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey, blurRadius: 5),
                                ]),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : defaultColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "العنوان  : ",
                                      style: TextStyle(
                                          color: cubit.isDark
                                              ? Colors.white
                                              : defaultColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      list["location"],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: cubit.isDark
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : defaultColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "الوظيفه  : ",
                                      style: TextStyle(
                                          color: cubit.isDark
                                              ? Colors.white
                                              : defaultColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      list["section"],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: cubit.isDark
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : defaultColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "الجنس  : ",
                                      style: TextStyle(
                                          color: cubit.isDark
                                              ? Colors.white
                                              : defaultColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${list["ginder"]}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: cubit.isDark
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          InkWell(
                            onTap: () {
                              navigateTo(
                                  context: context,
                                  widget: ProfileImages(
                                    id: list["id"],
                                  ));
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                  color: cubit.isDark
                                      ? Colors.grey[800]
                                      : defaultColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "معرض الاعمال",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
