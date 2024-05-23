import 'dart:convert';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:komanda/shared/components/components.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';
import '../chat/image_chat.dart';

class ProfileImages extends StatelessWidget {
  final int id;
  ProfileImages({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    CubitApp.get(context).getprofileImage(id: id);
    CubitApp.get(context).getProfileImage = null;
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;
          return Scaffold(
              appBar: AppBar(
                title: Text("معرض الصور"),
              ),
              body: ConditionalBuilder(
                  condition: cubit.getProfileImage != null,
                  builder: (context) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: cubit.getProfileImage!.isNotEmpty
                          ? GridView.count(
                              crossAxisCount: isDesktop ? 3 : 2,
                              shrinkWrap: true,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1 / 1.20,
                              physics: BouncingScrollPhysics(),
                              children: List.generate(
                                  cubit.getProfileImage!.length,
                                  (index) => InkWell(
                                    onTap: (){
                                      navigateTo(context: context, widget: ImageChat(image: cubit.getProfileImage![index]["img"],));
                                    },
                                    child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.memory(
                                            base64Decode(cubit
                                                .getProfileImage![index]["img"]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  )),
                            )
                          : Center(
                              child: Text(
                                "لا يوجد صور حتي الان",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            )),
                  fallback: (context) =>
                      Center(child: SpinKitThreeBounce(
                        color: defaultColor,
                        size: 30,
                      ))));
        });
  }
}
