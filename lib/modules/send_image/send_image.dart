import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../models/notification_model.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';

class SendImage extends StatefulWidget {
  const SendImage({super.key});

  @override
  State<SendImage> createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  File? _selectImage;
  File? _compressImage;
  String? imageSend;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(listener: (context, state) {
      if (state is EditProfileSuccessful) {
        if (CubitApp.get(context).sendImageMessage == "done") {
          NotificationService.showNotification(
              title: "تم ارسال الصورة بنجاح",
              body: " يمكنك رؤية الصور في معرض الاعمال ");
        } else {
          NotificationService.showNotification(
              title: " حدث خطأ اثناء الأرسال",
              body: "برجاء التأكد من اتصالك بالانترنت ثم اعد المحاولة");
        }
      } else if (state is SendImageError) {
        NotificationService.showNotification(
            title: " حدث خطأ اثناء الأرسال",
            body: "برجاء التأكد من اتصالك بالانترنت ثم اعد المحاولة");
      }
    }, builder: (context, state) {
      var cubit = CubitApp.get(context);
      final isDesktop = MediaQuery.of(context).size.width >= 500;
      final isSmallMobile = MediaQuery.of(context).size.width >= 300;
      return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _selectImage != null
                  ? Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        clipBehavior: Clip.antiAlias,
                        child: Image.file(
                          _selectImage!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: isSmallMobile ? 300 : 350,
                        ),
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  _picImageFromGallery();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: cubit.isDark ? Colors.grey[800] : defaultColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectImage != null ? "تغيير الصورة" : "اضافة صورة",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _selectImage != null
                  ? InkWell(
                      onTap: () {
                        cubit.sendImageToGallery(
                            userId: CacheHelper.getData(key: "UserId"),
                            img: imageSend!);
                        _selectImage = null;
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color:
                                cubit.isDark ? Colors.grey[800] : defaultColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ارسال الصورة",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
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
