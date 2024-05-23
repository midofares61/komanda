import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../models/notification_model.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';

class WithdrawScreen extends StatelessWidget {
  WithdrawScreen({super.key});
  var formKey = GlobalKey<FormState>();
  var valueController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(listener: (context, state) {
      if (state is WithdrawSuccessful) {
        if (CubitApp.get(context).messageWithdraw == "success") {
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
      final isDesktop = MediaQuery.of(context).size.width >= 500;
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("سحب"),
          ),
          body: SingleChildScrollView(
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
                        Text("اقل مبلغ لسحب 15 جنيه و اعلي مبلغ لسحب 10 تلاف",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: valueController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color:
                                  cubit.isDark ? Colors.white : Colors.black),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "يرجي ادخال المبلغ";
                            }
                            if (int.parse(value) < 15) {
                              return "اقل قيمة للسحب 15 جنيها";
                            }
                            if (int.parse(value) > 10000) {
                              return "اعلي قيمة للسحب  10 الاف جنيها";
                            }
                            if (int.parse(value) > cubit.profilModel!.val) {
                              return "رصيدك الحالي غير كافي رصيدك ${cubit.profilModel!.val} جنيه";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
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
                              color:
                                  cubit.isDark ? Colors.white : Colors.black),
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
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black)),
                              border: OutlineInputBorder(),
                              hintText: "الرقم المرسل اليه",
                              hintStyle: TextStyle(
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        defaultButton(
                            text: "تاكيد  السحب  ",
                            color: Colors.white,
                            background: defaultColor,
                            navigate: () {
                              if (formKey.currentState!.validate()) {
                                cubit.withdraw(
                                  total: valueController.text,
                                  resiveNum: phoneController.text,
                                  userId: CacheHelper.getData(key: "UserId"),
                                );
                                valueController.text = "";
                                phoneController.text = "";
                                cubit.messageWithdraw = "";
                              }
                            })
                      ]),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
