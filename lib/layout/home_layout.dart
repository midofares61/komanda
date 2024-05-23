import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../cubit/cubit_app.dart';
import '../cubit/state_app.dart';
import '../shared/network/local/chach_helper.dart';
import '../shared/styles/colors.dart';

class HomeLayout extends StatefulWidget {
  HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final PageStorageBucket bucket = PageStorageBucket();
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialoBox();
            setState(() => isAlertSet = true);
          }
        },
      );
  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CubitApp.get(context);
        final isDesktop = MediaQuery.of(context).size.width >= 500;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: PageStorage(
              bucket: bucket,
              child: cubit.screen[cubit.currentIndex],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.home,
                color: cubit.currentIndex == 0 ? Colors.white : Colors.black,
              ),
              onPressed: () {
                cubit.changeindex(0);
              },
              backgroundColor:
                  cubit.currentIndex == 0 ? defaultColor : Colors.white,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              color: cubit.isDark ? darkColor : Colors.white,
              shape: CircularNotchedRectangle(),
              notchMargin: 10,
              child: Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40 : 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              cubit.changeindex(1);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: cubit.isDark
                                      ? cubit.currentIndex == 1
                                          ? defaultColor
                                          : Colors.white
                                      : cubit.currentIndex == 1
                                          ? defaultColor
                                          : Colors.black,
                                ),
                                Text(
                                  "ملفي",
                                  style: TextStyle(
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: isDesktop ? 30 : 20,
                          ),
                          InkWell(
                            onTap: () {
                              cubit.changeindex(2);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications,
                                  color: cubit.isDark
                                      ? cubit.currentIndex == 2
                                          ? defaultColor
                                          : Colors.white
                                      : cubit.currentIndex == 2
                                          ? defaultColor
                                          : Colors.black,
                                ),
                                Text(
                                  "الاشعارات",
                                  style: TextStyle(
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.sizeOf(context).width / 2.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              cubit.changeindex(3);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: cubit.isDark
                                      ? cubit.currentIndex == 3
                                          ? defaultColor
                                          : Colors.white
                                      : cubit.currentIndex == 3
                                          ? defaultColor
                                          : Colors.black,
                                ),
                                Text(
                                  "المحادثات",
                                  style: TextStyle(
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: isDesktop ? 30 : 20,
                          ),
                          InkWell(
                            onTap: () {
                              cubit.changeindex(4);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.settings,
                                  color: cubit.isDark
                                      ? cubit.currentIndex == 4
                                          ? defaultColor
                                          : Colors.white
                                      : cubit.currentIndex == 4
                                          ? defaultColor
                                          : Colors.black,
                                ),
                                Text(
                                  "الضبط",
                                  style: TextStyle(
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showDialoBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text("لا يوجد اتصال بالانترنت"),
          content: const Text("من فضلك قم بالتحقق من اتصالك بالانترنت"),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  Navigator.pop(context, 'cancel');
                  setState(() => isAlertSet = false);
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected) {
                    showDialoBox();
                    setState(() => isAlertSet = true);
                  }
                },
                child: const Text("OK"))
          ],
        ),
      );
}


              // bottomNavigationBar: BottomNavigationBar(
              //   backgroundColor: defaultColor,
              //   selectedItemColor: Colors.black,
              //   unselectedItemColor: Colors.grey,
              //   onTap: (value) {
              //     cubit.changeindex(value);
              //   },
              //   currentIndex: cubit.currentIndex,
              //   items: cubit.bottomItem,
              // ),