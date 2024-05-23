import 'dart:convert';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:komanda/shared/locale/db.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';
import '../chat/chat_screen.dart';
import '../info/info_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CubitApp.get(context).getOrders(id: CacheHelper.getData(key: "UserId"));
    CubitApp.get(context).getChatReceiv(id: CacheHelper.getData(key: "UserId"));
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {

        },
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;

          return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  title: Text("المحادثات"),
                  bottom: TabBar(
                    tabs: [
                      Tab(
                        child: Text("مستلمة"),
                      ),
                      Tab(
                        child: Text("مرسلة"),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          navigateTo(context: context, widget: InfoScreeen());
                        },
                        icon: Icon(Icons.menu))
                  ],
                ),
                body: ConditionalBuilder(
                  condition: cubit.order != null && cubit.chatReceiv != null,
                  builder: (context) =>
                      TabBarView(physics: BouncingScrollPhysics(), children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: cubit.order!.isNotEmpty
                      ? ConditionalBuilder(
                          condition: cubit.order != null,
                          builder: (context) => RefreshIndicator(
                                onRefresh: () async {
                                  await Future.delayed(
                                      Duration(milliseconds: 500));
                                  CubitApp.get(context).getOrders(
                                      id: CacheHelper.getData(
                                          key: "UserId"));
                                },
                                child: ListView.separated(
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      navigateTo(
                                          context: context,
                                          widget: ChatScreen(
                                            id: cubit.order![index]
                                                ["receiver_id"],
                                            sender: cubit.order![index]
                                                ["sender_id"],
                                            name: cubit.order![index]
                                                ["sender_name"],
                                            image: cubit.order![index]
                                            ["sender_img"],
                                          ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${cubit.order![index]["sender_name"]}",
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 18,
                                                    color: cubit.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                cubit.order![index]
                                                [
                                                "the_end"] ==
                                                    null
                                                    ? Text(
                                                  "تم ارسال صورة",
                                                  style: TextStyle(
                                                      color: cubit.isDark
                                                          ? Colors
                                                          .white
                                                          : Colors
                                                          .black),
                                                  maxLines: 1,
                                                  overflow:
                                                  TextOverflow
                                                      .ellipsis,
                                                )
                                                    :
                                                Text(
                                                  "${cubit.order![index]["the_end"]}",
                                                  style: TextStyle(
                                                      color: cubit.isDark
                                                          ? Colors.white
                                                          : Colors.black),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(
                                                        2.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(50)
                                                  ),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Image.memory(base64Decode(cubit.order![index]["receiver_img"]),width: 60,height: 60,),
                                                ),
                                              ),
                                              cubit.order![index]
                                                              ["count"] ==
                                                          0 ||
                                                      CacheHelper.getData(
                                                              key:
                                                                  "UserId") ==
                                                          cubit.order![
                                                                  index]
                                                              ["end_seder"]
                                                  ? SizedBox()
                                                  : CircleAvatar(
                                                      radius: 10,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Text(
                                                        "${cubit.order![index]["count"]}",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black),
                                                      ),
                                                    )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      Container(
                                    color: secondeColor,
                                    height: 1,
                                    width: double.infinity,
                                  ),
                                  itemCount: cubit.order!.length,
                                ),
                              ),
                          fallback: (context) =>
                              Center(child: SpinKitThreeBounce(
                                color: defaultColor,
                                size: 30,
                              )))
                      : Center(
                          child: Text(
                            "لا يوجد رسائل مستلمة حتي الان",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: cubit.chatReceiv!.isNotEmpty
                            ? ConditionalBuilder(
                                condition: cubit.chatReceiv != null,
                                builder: (context) => RefreshIndicator(
                                      onRefresh: () async {
                                        await Future.delayed(
                                            Duration(milliseconds: 1000));
                                        CubitApp.get(context).getChatReceiv(
                                            id: CacheHelper.getData(
                                                key: "UserId"));
                                      },
                                      child: ListView.separated(
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                          onTap: () {
                                            navigateTo(
                                                context: context,
                                                widget: ChatScreen(
                                                  id: cubit.chatReceiv![index]
                                                      ["receiver_id"],
                                                  sender:
                                                      cubit.chatReceiv![index]
                                                          ["sender_id"],
                                                  name:
                                                      cubit.chatReceiv![index]
                                                          ["receiver_name"],
                                                  image: cubit.chatReceiv![index]
                                                  ["receiver_img"],
                                                ));
                                          },
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${cubit.chatReceiv![index]["receiver_name"]}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color: cubit.isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      cubit.chatReceiv![index]
                                                                  [
                                                                  "the_end"] ==
                                                              null
                                                          ? Text(
                                                              "تم ارسال صورة",
                                                              style: TextStyle(
                                                                  color: cubit.isDark
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )
                                                          : Text(
                                                              "${cubit.chatReceiv![index]["the_end"]}",
                                                              style: TextStyle(
                                                                  color: cubit.isDark
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10.0),
                                                  child: Stack(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(50)
                                                          ),
                                                          clipBehavior: Clip.antiAlias,
                                                          child: Image.memory(base64Decode(cubit.chatReceiv![index]["sender_img"]),width: 60,height: 60,),
                                                        ),
                                                      ),
                                                      cubit.chatReceiv![index]
                                                                      [
                                                                      "count"] ==
                                                                  0 ||
                                                              CacheHelper.getData(
                                                                      key:
                                                                          "UserId") ==
                                                                  cubit.chatReceiv![
                                                                          index]
                                                                      [
                                                                      "end_seder"]
                                                          ? SizedBox()
                                                          : CircleAvatar(
                                                              radius: 10,
                                                              backgroundColor:
                                                                  Colors
                                                                      .white,
                                                              child: Text(
                                                                "${cubit.chatReceiv![index]["count"]}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        separatorBuilder: (context, index) =>
                                            Container(
                                          color: secondeColor,
                                          height: 1,
                                          width: double.infinity,
                                        ),
                                        itemCount: cubit.chatReceiv!.length,
                                      ),
                                    ),
                                fallback: (context) => Center(
                                    child: SpinKitThreeBounce(
                                      color: defaultColor,
                                      size: 30,
                                    )))
                            : Center(
                                child: Text(
                                  "لا يوجد رسائل مرسلة حتي الان",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: cubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              )),
                  ]),
                  fallback: (context) => Center(
                    child: SpinKitThreeBounce(
                      color: defaultColor,
                      size: 30,
                    ),
                  ),
                )),
          );
        });
  }
}
