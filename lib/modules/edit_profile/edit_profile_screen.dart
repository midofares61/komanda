import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:komanda/shared/components/components.dart';
import 'package:komanda/shared/network/local/chach_helper.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../models/notification_model.dart';
import '../../shared/styles/colors.dart';

class EditProfileScreen extends StatefulWidget {
  final String location;
  final String jop;
  final String gender;
   EditProfileScreen({super.key,required this.gender,required this.jop,required this.location});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<String> genderList = ["ذكر", "انثي"];
  String? governValue;
  String? centerValue;
  String? genderValue;
  String? WorkValue;
  var isChoosegover = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(listener: (context, state) {
      if (state is EditProfileSuccessful) {
        if (CubitApp.get(context).editProfile == "done") {
          NotificationService.showNotification(
              title: "تم التعديل بنجاح",
              body: "");
        } else {
          NotificationService.showNotification(
              title: " حدث خطأ اثناء التعديل",
              body: "برجاء التأكد من اتصالك بالانترنت ثم اعد المحاولة");
        }
      } else if (state is EditProfileError) {
        NotificationService.showNotification(
            title: " حدث خطأ اثناء الأرسال",
            body: "برجاء التأكد من اتصالك بالانترنت ثم اعد المحاولة");
      }
    }, builder: (context, state) {
    var cubit = CubitApp.get(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("تعديل المعلومات الشخصية"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  cubit.getLocatioCity();
                  showModalBottomSheet(
                      context: context,
                      builder:
                          (context) => ConditionalBuilder(
                        condition:
                        cubit.getCity != null,
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets
                                .symmetric(
                                vertical: 5,
                                horizontal: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed:
                                            () {
                                          Navigator.pop(
                                              context);
                                        },
                                        icon: Icon(Icons
                                            .close)),
                                    Spacer(),
                                    Text(
                                        "اختار محافظة"),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView
                                      .separated(
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder:
                                          (context, index) =>
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  governValue = cubit.getCity![index];
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text(
                                                cubit.getCity![index],
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                      separatorBuilder:
                                          (context, index) =>
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                      itemCount: cubit
                                          .getCity!
                                          .length),
                                ),
                              ],
                            ),
                          );
                        },
                        fallback: (context) =>
                            Center(
                              child:
                              SpinKitThreeBounce(
                                color: defaultColor,
                                size: 30,
                              ),
                            ),
                      ));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(5),
                      border: Border.all(
                          width: 1, color: Colors.grey)),
                  child: Row(
                    children: [
                      Text(
                        governValue != null
                            ? governValue!
                            : "تعديل المحافظة",
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  governValue == null
                      ? setState(() {
                    isChoosegover = false;
                  })
                      : {
                    setState(() {
                      isChoosegover = true;
                    }),
                    cubit.getLocatio(
                        id: governValue!),
                    showModalBottomSheet(
                        context: context,
                        builder:
                            (context) =>
                            ConditionalBuilder(
                              condition: cubit
                                  .getLocation !=
                                  null,
                              builder: (context) {
                                return Container(
                                  padding: EdgeInsets
                                      .symmetric(
                                      vertical:
                                      5,
                                      horizontal:
                                      20),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                        20,
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed:
                                                  () {
                                                Navigator.pop(context);
                                              },
                                              icon:
                                              Icon(Icons.close)),
                                          Spacer(),
                                          Text(
                                              "اختار مدينة"),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                        10,
                                      ),
                                      Expanded(
                                        child: ListView.separated(
                                          physics: BouncingScrollPhysics(),
                                            itemBuilder: (context, index) => Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    centerValue = cubit.getLocation![index];
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text(
                                                  cubit.getLocation![index],
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            separatorBuilder: (context, index) => Container(
                                              width: double.infinity,
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                            itemCount: cubit.getLocation!.length),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              fallback:
                                  (context) =>
                                  Center(
                                    child:
                                    SpinKitThreeBounce(
                                      color: defaultColor,
                                      size: 30,
                                    ),
                                  ),
                            ))
                  };
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(5),
                      border: Border.all(
                          width: 1, color: Colors.grey)),
                  child: Row(
                    children: [
                      Text(
                        centerValue != null
                            ? centerValue!
                            : "تعديل المدينة",
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),
              isChoosegover
                  ? SizedBox()
                  : Container(
                  width: double.infinity,
                  padding:
                  EdgeInsets.only(top: 3, right: 5),
                  child: Text(
                    "يرجي اختيار محافظة اولا",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12),
                  )),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  if(cubit.listUnits.isEmpty){
                  cubit.getLogUnits();
                  }
                  showModalBottomSheet(
                      context: context,
                      builder:
                          (context) => ConditionalBuilder(
                        condition:
                        cubit.listUnits != null,
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets
                                .symmetric(
                                vertical: 5,
                                horizontal: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed:
                                            () {
                                          Navigator.pop(
                                              context);
                                        },
                                        icon: Icon(Icons
                                            .close)),
                                    Spacer(),
                                    Text(
                                        "اختار المهنة"),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: ListView
                                      .separated(
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder:
                                          (context, index) =>
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  WorkValue = cubit.listUnits![index];
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                  cubit.listUnits![index],
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                      separatorBuilder:
                                          (context, index) =>
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.grey,
                                          ),
                                      itemCount: cubit
                                          .listUnits!
                                          .length),
                                ),
                              ],
                            ),
                          );
                        },
                        fallback: (context) =>
                            Center(
                              child:
                              SpinKitThreeBounce(
                                color: defaultColor,
                                size: 30,
                              ),
                            ),
                      ));
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(5),
                      border: Border.all(
                          width: 1, color: Colors.grey)),
                  child: Row(
                    children: [
                      Text(
                        WorkValue != null
                            ? WorkValue!
                            : "تعديل المهنة",
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 15,vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: Colors.grey),
                    borderRadius:
                    BorderRadius.circular(
                        5)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: FittedBox(
                    child: const Text(
                      "--اختار الجنس--",
                      overflow: TextOverflow
                          .ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  underline: Container(),
                  value: genderValue,
                  style: const TextStyle(
                      color: defaultColor,
                      fontSize: 18),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      genderValue = value!;
                    });
                  },
                  items: genderList.map<
                      DropdownMenuItem<
                          String>>(
                          (String value) {
                        return DropdownMenuItem<
                            String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              defaultButton(text: "تعديل", color: Colors.white, background: defaultColor, navigate: (){
                cubit.EditProfile(userId: CacheHelper.getData(key: "UserId"),location: "$governValue - $centerValue",gender: "$genderValue",jop: "$WorkValue");
              })
            ],
          ),
        ),
      ),
    );});
  }
}
