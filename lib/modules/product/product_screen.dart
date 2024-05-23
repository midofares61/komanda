import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../layout/home_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../info/info_screen.dart';
import '../persons/persons_screen.dart';
import '../search/search_screen.dart';

class ProductScreen extends StatefulWidget {
  final String name;
  final String btn;
  final dynamic list;
  ProductScreen(
      {super.key, required this.name, required this.list, required this.btn});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool retry=false;
  List<Map> data = [
    {
      "name": "كهربائي",
      "image": "assets/images/flat-color-icons_home.svg",
    },
    {
      "name": "نجار",
      "image": "assets/images/twemoji_racing-car.svg",
    },
    {
      "name": "سباك ",
      "image": "assets/images/air-conditioner 1.svg",
    },
    {
      "name": "عامل  بلاط",
      "image": "assets/images/civil-engineering 5.svg",
    },
    {
      "name": "نقاش",
      "image": "assets/images/pesticide 1.svg",
    },
    {
      "name": "عامل نظافه",
      "image": "assets/images/flat-color-icons_home.svg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    CubitApp.get(context).units = null;
    CubitApp.get(context).getUnits(id: widget.list);
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {
          if(state is GetUnitsError){
            setState(() {
              retry=true;
            });
          }
        },
        builder: (context, state) {
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
              body:retry? Container(
                width: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    InkWell(
                    onTap: (){
                  CubitApp.get(context).getUnits(id: widget.list);
                setState(() {
            retry=false;
          });
          },
          child:Container(
            padding: EdgeInsets.symmetric(vertical: 30,horizontal: 25),
            decoration: BoxDecoration(
                color:cubit.isDark? Colors.white:Colors.transparent,
                borderRadius: BorderRadius.circular(100)
            ),
            child: Column(
                          children: [
                            Image(image: AssetImage("assets/images/reload.png",),
                              width: 50,
                            ),
                            SizedBox(height: 20,),
                            Text("يرجي تحديث الصفحة")
                          ],
                        ),
          ))
                    ],
                  ),
              )
              : ConditionalBuilder(
                  condition: cubit.units != null,
                  // cubit.units != null
                  builder: (context) => Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "المهن الاكثر طالبا",
                              style: TextStyle(
                                  color: cubit.isDark
                                      ? Colors.white
                                      : secondeColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 100,
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 5),
                                              ]),
                                          child: CircleAvatar(
                                            backgroundColor: cubit.isDark
                                                ? darkColor
                                                : defaultColor,
                                            child: SvgPicture.asset(
                                                data[index]["image"]),
                                            radius: 30,
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          data[index]["name"],
                                          style: TextStyle(
                                              color: cubit.isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: isDesktop ? 20 : 10),
                                itemCount: data.length,
                              ),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Expanded(
                                child: cubit.units!.isNotEmpty
                                    ? GridView.count(
                                        padding: EdgeInsets.all(10),
                                        crossAxisCount: isDesktop ? 3 : 2,
                                        shrinkWrap: true,
                                        mainAxisSpacing: isDesktop ? 20 : 10,
                                        crossAxisSpacing: isDesktop ? 20 : 10,
                                        childAspectRatio: 1 / 1.20,
                                        physics: BouncingScrollPhysics(),
                                        children: List.generate(
                                            cubit.units!.length,
                                            (index) => InkWell(
                                                  onTap: () {
                                                    navigateTo(
                                                        context: context,
                                                        widget: PersonsScreen(
                                                          name: cubit
                                                                  .units![index]
                                                              ["name"],
                                                          nameB: cubit
                                                                  .units![index]
                                                              ["name"],
                                                        ));
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color:
                                                                  Colors.grey,
                                                              blurRadius: 2),
                                                        ],
                                                        color: cubit.isDark
                                                            ? darkColor
                                                            : secondeColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.grey[300],
                                                          child: SvgPicture
                                                              .asset(data[index]
                                                                  ["image"]),
                                                          radius: 30,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8),
                                                          child: Text(
                                                            cubit.units![index]
                                                                ["name"],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                        Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        3),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    thirdColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Text(
                                                              widget.btn,
                                                              style: TextStyle(
                                                                  color:
                                                                      defaultColor,
                                                                  fontSize: 16),
                                                            ))
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                      )
                                    : Center(
                                        child: Text(
                                          "لا يوجد اقسام حتي الان",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ))
                          ],
                        ),
                      ),
                  fallback: (context) => Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "المهن الاكثر طالبا",
                          style: TextStyle(
                              color: cubit.isDark
                                  ? Colors.white
                                  : secondeColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 5),
                                        ]),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                                      child: CircleAvatar(
                                        backgroundColor:
                                        Colors.grey[300],
                                        radius: 30,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Shimmer.fromColors(
                                    baseColor:Colors.grey.shade300 ,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      width: 50,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                SizedBox(width: isDesktop ? 20 : 15),
                            itemCount: data.length,
                          ),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Expanded(
                            child: GridView.count(
                              padding: EdgeInsets.all(10),
                              crossAxisCount: isDesktop ? 3 : 2,
                              shrinkWrap: true,
                              mainAxisSpacing: isDesktop ? 20 : 10,
                              crossAxisSpacing: isDesktop ? 20 : 10,
                              childAspectRatio: 1 / 1.20,
                              physics: BouncingScrollPhysics(),
                              children: List.generate(
                                  5,
                                      (index) => Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color:
                                                  Colors.grey,
                                                  blurRadius: 2),
                                            ],
                                            color: cubit.isDark
                                                ? Colors.grey[300]
                                                : Colors.white,
                                            borderRadius:
                                            BorderRadius
                                                .circular(20)),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                Colors.grey[300],
                                                radius: 30,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                  vertical: 8),
                                              child: Text(
                                                "",
                                                style: TextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                  Shimmer.fromColors(child:  Container(
                                      padding: EdgeInsets
                                          .symmetric(
                                          horizontal:
                                          15,
                                          vertical:
                                          15),
                                      decoration: BoxDecoration(
                                          color:
                                          thirdColor,
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              20)),), baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100)
                                          ],
                                        ),
                                      )),
                            )
                        )
                      ],
                    ),
                  ),),
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
}
