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
import '../profile_person/profile_person_screen.dart';

class PersonBuildAnimation extends StatefulWidget {
  const PersonBuildAnimation({super.key,required this.data});
  final List data;

  @override
  State<PersonBuildAnimation> createState() => _PersonBuildAnimationState();
}

class _PersonBuildAnimationState extends State<PersonBuildAnimation> {
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
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {
    },
    builder: (context, state) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;
    var cubit = CubitApp.get(context);
    final isDesktop = MediaQuery.of(context).size.width >= 500;

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) =>widget.data[index]["val"]<=0?SizedBox():AnimatedContainer(
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(
            startAnimation ? 0 : (-1*screenWidth), 0, 0),
        duration: Duration(milliseconds: 400 + (index * 200)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 40,
                  bottom: 20),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: cubit.isDark
                        ? darkColor
                        : defaultColor,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5),
                    ],
                    borderRadius:
                    BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(
                          right: 60),
                      child: Container(
                        width: 170,
                        child: Text(
                          "${widget.data![index]["name"]}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight:
                              FontWeight
                                  .bold),
                          maxLines: 1,
                          overflow: TextOverflow
                              .ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int n = 0;
                        n < 5 - widget.data[index]["stars"];
                        n++)
                          Icon(Icons.star, color: Colors.grey),
                        for (int n = 0;
                        n < widget.data[index]["stars"];
                        n++)
                          Icon(
                            Icons.star,
                            color: Color.fromARGB(255, 255, 217, 0),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "أسعى دائمًا لتحسين وتطوير مهاراتي ومعرفتي في مجالي لتقديم أفضل الخدمات للعملاء. بفضل مرونة العمل كعامل حر، أستمتع بالقدرة على تكوين شراكات مع مختلف العملاء والمشاريع.أقدم خدماتي كعامل حر بروح إبداعية واهتمام شديد بتحقيق أهداف العملاء وتلبية توقعاتهم.",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight:
                          FontWeight.bold),
                      maxLines:2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceAround,
                      children: [
                        Container(
                          padding:
                          EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 10),
                          decoration: BoxDecoration(
                              color: thirdColor,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  20)),
                          child: InkWell(
                            onTap: () {
                              navigateTo(
                                  context: context,
                                  widget:
                                  ChatScreen(
                                    id: widget.data[
                                    index]
                                    ["id"],
                                    sender: CacheHelper
                                        .getData(
                                        key:
                                        "UserId"),
                                    name: widget.data[
                                    index]
                                    ["name"],
                                    image: widget.data[index]
                                    ["img"],
                                  ));
                            },
                            child: Row(
                              children: [
                                Text("رسلني"),
                                SizedBox(
                                  width: 10,
                                ),
                                SvgPicture.asset(
                                    "assets/images/messenger.svg")
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding:
                          EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 10),
                          decoration: BoxDecoration(
                              color: thirdColor,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  20)),
                          child: InkWell(
                            onTap: () {
                              navigateTo(
                                  context: context,
                                  widget:
                                  ProfilePersonScreen(
                                    list:
                                    widget.data[
                                    index],
                                  ));
                            },
                            child: Row(
                              children: [
                                Text(
                                    "الملف الشخصي"),
                                SizedBox(
                                  width: 10,
                                ),
                                SvgPicture.asset(
                                    "assets/images/profile.svg")
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(

                    borderRadius:
                    BorderRadius.circular(100)),
                clipBehavior: Clip.antiAlias,
                child: Image.memory(base64Decode(widget.data[index]["img"]),width: 100,height: 100,))
          ],
        ),
      ),
      separatorBuilder: (context, index) =>
          SizedBox(
            height: isDesktop ? 10 : 0,
          ),
      itemCount: widget.data.length,
    );});
  }
}
