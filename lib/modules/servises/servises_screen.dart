import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../layout/home_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../build_item_animation/build_animation_screen.dart';
import '../info/info_screen.dart';
import '../product/product_screen.dart';
import '../search/search_screen.dart';

class ServisesScreen extends StatefulWidget {
  final String name;

  ServisesScreen({super.key, required this.name});

  @override
  State<ServisesScreen> createState() => _ServisesScreenState();
}

class _ServisesScreenState extends State<ServisesScreen> {
  double screenWidth = 0;
  double screenHeight = 0;
  bool retry = false;


  @override
  Widget build(BuildContext context) {
    if (CubitApp.get(context).section == null)
      CubitApp.get(context).getSection();
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return BlocConsumer<CubitApp, StateApp>(listener: (context, state) {
      if (state is GetSectionError) {
        setState(() {
          retry = true;
        });
      }
    }, builder: (context, state) {
      var cubit = CubitApp.get(context);
      final isDesktop = MediaQuery.of(context).size.width >= 500;
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            leading: Text(""),
            title: Text(widget.name),
            actions: [
              IconButton(
                onPressed: () {
                  navigateTo(context: context, widget: SearchScreen());
                },
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  navigateTo(context: context, widget: InfoScreeen());
                },
                icon: Icon(
                  Icons.menu,
                  size: 35,
                ),
              )
            ],
          ),
          body: retry
              ? Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            CubitApp.get(context).getSection();
                            setState(() {
                              retry = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 30,horizontal: 25),
                            decoration: BoxDecoration(
                                color:cubit.isDark? Colors.white:Colors.transparent,
                                borderRadius: BorderRadius.circular(100)
                            ),
                            child: Column(
                              children: [
                                Image(
                                  image: AssetImage(
                                    "assets/images/reload.png",
                                  ),
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("يرجي تحديث الصفحة")
                              ],
                            ),
                          ))
                    ],
                  ),
                )
              : ConditionalBuilder(
                  condition: cubit.section != null,
                  builder: (context) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: cubit.section!.isNotEmpty
                          ?
                      buildItemsAnimation(
                        color: cubit.isDark
                            ? darkColor
                            : defaultColor, name: widget.name, data: cubit.section!,)

                          : Center(
                              child: FittedBox(
                                child: Text(
                                  "لا يوجد خدمات حتي الان",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: cubit.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            )),
                  fallback: (context) => Center(
                          child: SpinKitThreeBounce(
                        color: defaultColor,
                        size: 30,
                      ))),
          floatingActionButton: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                borderRadius: BorderRadius.circular(50)),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeLayout()),
                    (route) => false);
              },
              child: Icon(Icons.home),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      );
    });
  }

  // Widget buildItemsAnimation(Map<String, dynamic> data, int index,
  //         bool isDesktop, context, widget, color) =>
  //     InkWell(
  //       onTap: () {
  //         navigateTo(context: context, widget: widget);
  //       },
  //       child: AnimatedContainer(
  //         padding: EdgeInsets.all(15),
  //         curve: Curves.easeInOut,
  //         width: screenWidth,
  //         transform: Matrix4.translationValues(
  //             0, startAnimation ? 0 : (screenHeight), 0),
  //         duration: Duration(milliseconds: 400 + (index * 200)),
  //         decoration: BoxDecoration(
  //           color: color,
  //           boxShadow: [
  //             BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 5)
  //           ],
  //           borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(70),
  //               bottomRight: Radius.circular(70),
  //               bottomLeft: Radius.circular(10),
  //               topRight: Radius.circular(10)),
  //         ),
  //         child: Column(children: [
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               SvgPicture.asset("assets/images/air-conditioner 1.svg"),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               Text(
  //                 data["name"],
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: isDesktop ? 25 : 20,
  //                     fontWeight: FontWeight.bold),
  //                 textAlign: TextAlign.center,
  //               )
  //             ],
  //           ),
  //           Container(
  //             padding: EdgeInsets.all(25),
  //             child: Text(
  //               data["descreption"],
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: isDesktop ? 20 : 13,
  //               ),
  //             ),
  //           )
  //         ]),
  //       ),
  //     );
}

