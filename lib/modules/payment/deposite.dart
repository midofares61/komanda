import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';


import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../models/notification_model.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';

class DepositeScreen extends StatefulWidget {
  const DepositeScreen({super.key});

  @override
  State<DepositeScreen> createState() => _DepositeScreenState();
}

class _DepositeScreenState extends State<DepositeScreen> {
  var formKey = GlobalKey<FormState>();
  List<String> numbers = ["012000221332", "010123789162", "010273682735"];
  String? numbersValue;
  File? _selectImage;
  File? _compressImage;
  String? imageSend;
  var valueController = TextEditingController();
  var phoneController = TextEditingController();
  var choose = true;
  var select = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(listener: (context, state) {
      if (state is DepositeSuccessful) {
        if (CubitApp.get(context).messageDeposite == "success") {
          NotificationService.showNotification(
              title: "تم ارسال الطلب بنجاح",
              body: " قد يستغرق الرد من 5 دقائق الي 3 ساعات");
        } else {
          NotificationService.showNotification(
              title: " حدث خطأ اثناء الأرسال",
              body: "برجاء التأكد من صحة البيانات وإعادة المحاولة");
        }
      }
    }, builder: (context, state) {
      var cubit = CubitApp.get(context);

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              title: Text("ايداع"),
            ),
            body: ConditionalBuilder(
                condition: cubit.listPayNum.isNotEmpty,
                builder: (context) => SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          width: double.infinity,
                          child: Form(
                            key: formKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ملحوظه",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: defaultColor,
                                        fontSize: 20),
                                  ),
                                  Text(
                                      "اقل مبلغ لايداع 15 جنيه و اعلي مبلغ لسحب  10,000",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: cubit.isDark
                                              ? Colors.white
                                              : Colors.black)),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    controller: valueController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                        color: cubit.isDark
                                            ? Colors.white
                                            : Colors.black),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "يرجي ادخال المبلغ";
                                      }
                                      if (int.parse(value) < 15) {
                                        return "اقل قيمة للايداع 15 جنيها";
                                      }
                                      if (int.parse(value) > 10000) {
                                        return "اعلي قيمة للسحب  10 الاف جنيها";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : Colors.black)),
                                        border: OutlineInputBorder(),
                                        hintText: "ادخل المبلغ",
                                        hintStyle: TextStyle(
                                            color: cubit.isDark
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 11,
                                    style: TextStyle(
                                        color: cubit.isDark
                                            ? Colors.white
                                            : Colors.black),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "يرجي ادخال الرقم";
                                      }
                                      if (value.length != 11) {
                                        return "هذا الرقم غير صحيح او غير كامل";
                                      }
                                      if (!value.startsWith("01")) {
                                        return "يجب ان يبدأ الرقم ب 01";
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        counterText: "",
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: cubit.isDark
                                                    ? Colors.white
                                                    : Colors.black)),
                                        border: OutlineInputBorder(),
                                        hintText: "الرقم المرسل منه",
                                        hintStyle: TextStyle(
                                            color: cubit.isDark
                                                ? Colors.white
                                                : Colors.black)),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: choose
                                                ? Colors.grey
                                                : Colors.red),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text(
                                        "الرقم المرسل اليه",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: cubit.isDark
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      underline: Container(),
                                      value: numbersValue,
                                      style: TextStyle(
                                          color: cubit.isDark
                                              ? Colors.grey
                                              : defaultColor,
                                          fontSize: 18),
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          numbersValue = value!;
                                        });
                                      },
                                      items: cubit.listPayNum
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  choose
                                      ? SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0, top: 5),
                                          child: Text(
                                            "يرجي اختيار الرقم المرسل اليه",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            width: 1,
                                            color: select
                                                ? Colors.grey
                                                : Colors.red)),
                                    child: TextButton(
                                      onPressed: () {
                                        _picImageFromGallery();
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "ارفاق صوره",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.add_photo_alternate,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  select
                                      ? SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0, top: 5),
                                          child: Text(
                                            "يرجي اختيار الصورة",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  _selectImage != null
                                      ? Image.file(_selectImage!)
                                      : const SizedBox(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  defaultButton(
                                      text: "تاكيد الدفع ",
                                      color: Colors.white,
                                      background: defaultColor,
                                      navigate: () {
                                        numbersValue != null
                                            ? setState(() {
                                                choose = true;
                                              })
                                            : setState(() {
                                                choose = false;
                                              });
                                        _selectImage != null
                                            ? setState(() {
                                                select = true;
                                              })
                                            : setState(() {
                                                select = false;
                                              });

                                        if (formKey.currentState!.validate() &&
                                            _selectImage != null &&
                                            numbersValue != null) {
                                          cubit.deposit(
                                              total: valueController.text,
                                              resentNum: phoneController.text,
                                              resiveNum: numbersValue,
                                              userId: CacheHelper.getData(
                                                  key: "UserId"),
                                              image: imageSend!);
                                        }
                                        valueController.text = "";
                                        phoneController.text = "";
                                        numbersValue = null;
                                        _selectImage = null;
                                      })
                                ]),
                          ),
                        ),
                      ),
                    ),
                fallback: (context) => Center(
                      child: SpinKitThreeBounce(
                        color: defaultColor,
                        size: 30,
                      ),
                    ))),
      );
    });
  }

  Future _picImageFromGallery() async {
    final XFile? returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;

    final image = File(returnImage.path);
    if (!image.existsSync()) return; // التحقق من وجود الصورة

    setState(() {
      _selectImage = image;
      print("_selectImage$_selectImage");
      compress(image);
    });
  }

  Future convertImage(File image) async {
    Uint8List imageBytes = await image.readAsBytes();
    String base64string = base64.encode(imageBytes);
    setState(() {
      imageSend = base64string;
      print("convertImage$imageSend");
      print(imageSend);
    });
  }

  Future<void> compress(File _selectImage) async {
    print("_selectImage compress${_selectImage.path}");
    if (_selectImage == null) {
      // إذا كان _selectImage هو null، قم بإيقاف تنفيذ الدالة
      return print("null");
    }

    var result = await FlutterImageCompress.compressAndGetFile(
      _selectImage.path,
      '/data/user/0/com.example.komanda/compress.jpg',
      quality: 5,
    );
    print("result$result");
    if (result == null) {
      // إذا كان result هو null، قم بإيقاف تنفيذ الدالة
      return print("result=null");
    }

    setState(() {
      _compressImage = File(result.path);
      print("_compressImage$_compressImage");
      convertImage(_compressImage!);
    });
  }
}
