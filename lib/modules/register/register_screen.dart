import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../layout/home_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';
import '../login/cubit/cubit.dart';
import '../login/cubit/states.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  List<String> gender = ["ذكر", "انثي"];
  List<String> clinet = ["عميل", "فني", "تاجر"];
  String? governValue;
  String? centerValue;
  String? clinetValue;
  String? storeValue;
  String? workValue;
  String? genderValue;
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var locationController = TextEditingController();
  var passwordController = TextEditingController();
  var repasswordController = TextEditingController();
  var isregisterSecure = true;
  var isChoosegover = true;

  @override
  Widget build(BuildContext context) {
    final ismobile = MediaQuery.of(context).size.width <= 500;
    return BlocConsumer<CubitApp, StateApp>(listener: (context, state) {
      if (CubitApp.get(context).registerModel != null) {
        CacheHelper.SaveData(
            key: "UserId", value: CubitApp.get(context).registerModel?.tokenId);
        CacheHelper.SaveData(
                key: "token", value: CubitApp.get(context).registerModel?.token)
            .then((value) {
          navigateToFinish(context: context, widget: HomeLayout());
        });
      }
    }, builder: (context, state) {
      var cubit = CubitApp.get(context);

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: ConditionalBuilder(
              condition:
                  cubit.listUnits.isNotEmpty && cubit.listStories.isNotEmpty,
              builder: (context) {
                return SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.all(ismobile ? 20.0 : 40),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 70,
                            ),
                            Image(
                              image: AssetImage("assets/images/icon.png"),
                              width: 150,
                              height: 150,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FittedBox(
                              child: Text(
                                "مرحبا بكم في كوماندا",
                                style: TextStyle(
                                    color: defaultColor,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownButton<String>(
                                hint: Text("نوع الحساب"),
                                isExpanded: true,
                                underline: Container(),
                                value: clinetValue,
                                style: const TextStyle(
                                    color: defaultColor, fontSize: 18),
                                onChanged: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    clinetValue = value!;
                                  });
                                },
                                items: clinet.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "يجب ادخال الاسم ";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        label: Text("الاسم"),
                                        prefixIcon: Icon(Icons.text_fields),
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 11,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "يرجي ادخال الرقم ";
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
                                        label: Text("رقم الموبايل"),
                                        prefixIcon: Icon(Icons.phone),
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "يجب ادخال البريد الالكتروني ";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        label: Text("البريد الالكتروني"),
                                        prefixIcon: Icon(Icons.email),
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
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
                                                          CircularProgressIndicator(),
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
                                                : "يرجي اختيار محافظة",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Spacer(),
                                          Icon(Icons.arrow_drop_down)
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
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
                                                                          itemBuilder: (context, index) => InkWell(
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
                                                                  CircularProgressIndicator(),
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
                                                : "يرجي اختيار مدينة",
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
                                    height: 20,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: clinetValue == "فني"
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
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
                                                        "--اختار مهنة--",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    underline: Container(),
                                                    value: workValue,
                                                    style: const TextStyle(
                                                        color: defaultColor,
                                                        fontSize: 18),
                                                    onChanged: (String? value) {
                                                      // This is called when the user selects an item.
                                                      setState(() {
                                                        workValue = value!;
                                                      });
                                                    },
                                                    items: cubit.listUnits.map<
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
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
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
                                                    items: gender.map<
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
                                              ),
                                            ],
                                          )
                                        : clinetValue == "تاجر"
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: DropdownButton<
                                                          String>(
                                                        isExpanded: true,
                                                        hint: FittedBox(
                                                          child: const Text(
                                                            "--اختار نشاط--",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                        underline: Container(),
                                                        value: storeValue,
                                                        style: const TextStyle(
                                                            color: defaultColor,
                                                            fontSize: 18),
                                                        onChanged:
                                                            (String? value) {
                                                          // This is called when the user selects an item.
                                                          setState(() {
                                                            storeValue = value!;
                                                          });
                                                        },
                                                        items: cubit.listStories.map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: DropdownButton<
                                                          String>(
                                                        isExpanded: true,
                                                        hint: FittedBox(
                                                          child: const Text(
                                                            "--اختار الجنس--",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                        underline: Container(),
                                                        value: genderValue,
                                                        style: const TextStyle(
                                                            color: defaultColor,
                                                            fontSize: 18),
                                                        onChanged:
                                                            (String? value) {
                                                          // This is called when the user selects an item.
                                                          setState(() {
                                                            genderValue =
                                                                value!;
                                                          });
                                                        },
                                                        items: gender.map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: DropdownButton<String>(
                                                  isExpanded: true,
                                                  hint: const Text(
                                                    "--اختار الجنس--",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
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
                                                  items: gender.map<
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
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: isregisterSecure,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "يجب ان تتكون كلمة السر من 8 احرف علي الافل";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        label: Text("كلمة السر"),
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isregisterSecure =
                                                  !isregisterSecure;
                                            });
                                          },
                                          icon: Icon(isregisterSecure
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                        ),
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: repasswordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: isregisterSecure,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "يجب ان تتكون كلمة السر من 8 احرف علي الافل";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        label: Text("تأكيد كلمة السر"),
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isregisterSecure =
                                                  !isregisterSecure;
                                            });
                                          },
                                          icon: Icon(isregisterSecure
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                        ),
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  defaultButton(
                                      text: "انشاء حساب",
                                      color: Colors.white,
                                      background: defaultColor,
                                      navigate: () {
                                        if (formKey.currentState!.validate() &&
                                            clinetValue != null &&
                                            genderValue != null) {
                                          cubit.registration(
                                              name: nameController.text,
                                              email: emailController.text,
                                              phone: phoneController.text,
                                              ginder: genderValue!,
                                              section: clinetValue! == "فني"
                                                  ? workValue!
                                                  : clinetValue! == "تاجر"
                                                      ? storeValue!
                                                      : "null",
                                              plan: clinetValue!,
                                              password: passwordController.text,
                                              location:
                                                  "${governValue!}-${centerValue!}");
                                        }
                                      }),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  "لديك حساب ؟",
                                  style: TextStyle(fontSize: 18),
                                ),
                                TextButton(
                                    onPressed: () {
                                      navigateToFinish(
                                          context: context,
                                          widget: LoginScreen());
                                    },
                                    child: Text(
                                      "قم بتسجيل الدخول",
                                      style: TextStyle(
                                          fontSize: 18, color: defaultColor),
                                    ))
                              ],
                            )
                          ],
                        ),
                      )),
                );
              },
              fallback: (context) => Center(child: CircularProgressIndicator()),
            )),
      );
    });
  }
}
