import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:komanda/modules/edit_profile/edit_profile_screen.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';
import '../chat/chat_screen.dart';
import '../payment/payment_screen.dart';
import '../profile_image/profile_image.dart';
import '../send_image/send_image.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _selectImage;
  File? _compressImage;
  String? imageSend;
  final formKey = GlobalKey<FormState>();
  var codeController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    CubitApp.get(context).profilModel==null?CubitApp.get(context).getProfile(id: CacheHelper.getData(key: "UserId")):null;
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;
          return ConditionalBuilder(
            condition: cubit.profilModel != null,
            builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: isDesktop
                          ? const EdgeInsets.all(80.0)
                          : const EdgeInsets.all(20.0),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Container(
                                    decoration: BoxDecoration(

                                        borderRadius:
                                        BorderRadius.circular(100)),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.memory(
                                      base64Decode("${cubit.profilModel!.img}"),
                                      width: 100,
                                      height: 100,
                                    )),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 2, color: defaultColor),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Icon(
                                    Icons.edit_square,
                                    color: defaultColor,
                                    size: 16,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${cubit.profilModel?.name}",
                              style: TextStyle(
                                  color: cubit.isDark
                                      ? Colors.white
                                      : defaultColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int n = 0;
                                    n < 5 - cubit.profilModel?.stars;
                                    n++)
                                  Icon(Icons.star, color: Colors.grey),
                                for (int n = 0;
                                    n < cubit.profilModel?.stars;
                                    n++)
                                  Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 255, 217, 0),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              decoration: BoxDecoration(
                                  color:
                                  cubit.isDark ? darkColor : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey, blurRadius: 10),
                                  ]),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "كود الدعوة الخاص بك شاركه واربح النقود",
                                        style: TextStyle(
                                            color: cubit.isDark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5,),
                                      SelectableText(
                                        "${cubit.profilModel?.userId}",
                                        style: TextStyle(
                                            color: cubit.isDark
                                                ? Colors.white
                                                : defaultColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  IconButton(onPressed: (){
                                    Clipboard.setData(ClipboardData(text:  "${cubit.profilModel?.userId}"));
                                    Fluttertoast.showToast(msg: "تم نسخ كود الدعوة بنجاح");
                                  }, icon: Icon(Icons.collections_bookmark,color: defaultColor,))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            cubit.profilModel!.sendId==null?Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 15),
                                    decoration: BoxDecoration(
                                        color:
                                        cubit.isDark ? darkColor : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey, blurRadius: 10),
                                        ]),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: codeController,
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                                color:
                                                cubit.isDark ? Colors.white : Colors.black),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "يجب ادخال كود الدعوة ";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              isDense:true,
                                              hintText: "ادخل كود الدعوة واربح النقود",
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.grey)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: cubit.isDark
                                                          ? Colors.white
                                                          : Colors.black)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        InkWell(
                                          onTap: (){
                                            if(formKey.currentState!.validate()){
                                              if(codeController.text==cubit.profilModel?.userId){
                                                Fluttertoast.showToast(msg: "لا يمكنك دعوة نفسك");
                                              }else{
                                                cubit.getCodeVerification(code: codeController.text,id: CacheHelper.getData(key: "UserId"));
                                                codeController.text="";
                                                Fluttertoast.showToast(msg: "جاري مراجعة الطلب");
                                              }
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                            decoration: BoxDecoration(
                                                color: defaultColor,
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Text(
                                              "ادخال",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            ):Container(),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              decoration: BoxDecoration(
                                  color:
                                      cubit.isDark ? darkColor : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey, blurRadius: 10),
                                  ]),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                2,
                                        child: FittedBox(
                                          child: Text(
                                            "المعلومات الشخصية",
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: (){
                                          navigateTo(context: context, widget: EditProfileScreen(gender: "${cubit.profilModel?.ginder}", jop: "${cubit.profilModel?.section}", location: "${cubit.profilModel?.location}"));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit_square,
                                              color: defaultColor,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            FittedBox(
                                              child: Text(
                                                "تعديل",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: cubit.isDark
                                                        ? Colors.grey
                                                        : defaultColor,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                        "${cubit.profilModel?.location}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                  cubit.profilModel!.plan == "عميل"
                                      ? SizedBox()
                                      : Row(
                                          children: [
                                            Icon(
                                              Icons.work,
                                              color: cubit.isDark
                                                  ? Colors.white
                                                  : defaultColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "المهنة  : ",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                              "${cubit.profilModel?.section}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                        "${cubit.profilModel?.ginder}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                  color:
                                      cubit.isDark ? darkColor : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey, blurRadius: 10),
                                  ]),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                2,
                                        child: FittedBox(
                                          child: Text(
                                            "بيانات الاتصال",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: (){
                                          Fluttertoast.showToast(
                                              msg: "لا يمكن تغيير البيانات المطلوبة في الوقت الحالي",
                                              gravity: ToastGravity.BOTTOM,
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.green,
                                              timeInSecForIosWeb: 1,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit_square,
                                              color: defaultColor,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "تعديل",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: cubit.isDark
                                                      ? Colors.grey
                                                      : defaultColor,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text("البريد الألكتروني : ",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: cubit.isDark
                                                  ? Colors.white
                                                  : defaultColor)),
                                      Spacer(),
                                      Text(
                                        "${cubit.profilModel?.email}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: cubit.isDark
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text("رقم الهاتف :",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: cubit.isDark
                                                  ? Colors.white
                                                  : defaultColor)),
                                      Spacer(),
                                      Text(
                                        "${cubit.profilModel?.phone}",
                                        style: TextStyle(
                                          fontSize: 14,
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
                                    widget: PaymentScreen(
                                      value: cubit.profilModel?.val,
                                    ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color:
                                        cubit.isDark ? darkColor : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 10),
                                    ]),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      "الرصيد",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: cubit.isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.payments_sharp,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            cubit.profilModel!.plan == "فني"
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: cubit.isDark
                                            ? darkColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 10),
                                        ]),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          " معرض الاعمال  ",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: cubit.isDark
                                                ? Colors.white
                                                : defaultColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  navigateTo(
                                                      context: context,
                                                      widget: SendImage());
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      color: cubit.isDark
                                                          ? Colors.grey[800]
                                                          : defaultColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "اضافة صورة",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  navigateTo(
                                                      context: context,
                                                      widget: ProfileImages(
                                                        id: CacheHelper.getData(
                                                            key: "UserId"),
                                                      ));
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      color: cubit.isDark
                                                          ? Colors.grey[800]
                                                          : defaultColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "عرض الصور",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                : cubit.profilModel!.plan == "تاجر"
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: cubit.isDark
                                                ? darkColor
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 10),
                                            ]),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "كتالوج صور",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : defaultColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      navigateTo(
                                                          context: context,
                                                          widget: SendImage());
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                          color: cubit.isDark
                                                              ? Colors.grey[800]
                                                              : defaultColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "اضافة صورة",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      navigateTo(
                                                          context: context,
                                                          widget: ProfileImages(
                                                            id: CacheHelper
                                                                .getData(
                                                                    key:
                                                                        "UserId"),
                                                          ));
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      decoration: BoxDecoration(
                                                          color: cubit.isDark
                                                              ? Colors.grey[800]
                                                              : defaultColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "عرض الصور",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : Container()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            fallback: (Context) => Center(
              child: SpinKitThreeBounce(
                color: defaultColor,
                size: 30,
              ),
            ),
          );
        });
  }
}
