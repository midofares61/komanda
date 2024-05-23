import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class StoriesScreen extends StatefulWidget {
  final String name;

  StoriesScreen({super.key, required this.name});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  bool retry=false;
  @override
  Widget build(BuildContext context) {
    CubitApp.get(context).getStories();
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {
          if(state is GetStoriesError){
            setState(() {
              retry=true;
            });}
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
                          CubitApp.get(context).getStories();
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
                  condition: cubit.stories != null,
                  builder: (context) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: cubit.stories!.isNotEmpty
                          ? buildItemsAnimation(
                        color: cubit.isDark
                            ? darkColor
                            : defaultColor, name: widget.name, data:cubit.stories!,)
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
                  fallback: (context) =>
                      Center(child: SpinKitThreeBounce(
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
}
