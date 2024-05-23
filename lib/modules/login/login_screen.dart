import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../layout/home_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription =
        Connectivity().onConnectivityChanged.listen(_showConnectivitySnackBar);
  }

  void _showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final messege = hasInternet ? null : "No internet connection";
  }

  _showSnackBar(BuildContext context, String messege) {
    if (messege != null) {
      final snackBar = SnackBar(content: Text(messege));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  final formKey = GlobalKey<FormState>();

  var phoneController = TextEditingController();

  var passwordController = TextEditingController();
  var isLoginSecure = true;

  @override
  Widget build(BuildContext context) {
    final ismobile = MediaQuery.of(context).size.width <= 500;
    return BlocConsumer<CubitApp, StateApp>(listener: (context, state) {
      if (CubitApp.get(context).loginModel != null) {
        CacheHelper.SaveData(
            key: "UserId", value: CubitApp.get(context).loginModel?.user?.id);
        CacheHelper.SaveData(
                key: "token", value: CubitApp.get(context).loginModel?.token)
            .then((value) {
          navigateToFinish(context: context, widget: HomeLayout());
        });
      }
    }, builder: (context, state) {
      var cubit = CubitApp.get(context);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(ismobile ? 20 : 40.0),
              child: Column(
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
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                              color:
                                  cubit.isDark ? Colors.white : Colors.black),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "يجب ان يكون رقم الموبايل علي الاقل 11 رقما ";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black)),
                              label: FittedBox(
                                child: Text("رقم الموبايل",
                                    style: TextStyle(
                                        color: cubit.isDark
                                            ? Colors.white
                                            : Colors.black)),
                              ),
                              prefixIcon: Icon(
                                Icons.phone,
                                color:
                                    cubit.isDark ? Colors.white : defaultColor,
                              ),
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isLoginSecure,
                          style: TextStyle(
                              color:
                                  cubit.isDark ? Colors.white : Colors.black),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "يجب ان تتكون كلمة السر من 8 احرف علي الافل";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black)),
                              label: FittedBox(
                                child: Text(
                                  "كلمة السر",
                                  style: TextStyle(
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              prefixIcon: Icon(Icons.lock,
                                  color: cubit.isDark
                                      ? Colors.white
                                      : defaultColor),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isLoginSecure = !isLoginSecure;
                                  });
                                },
                                icon: Icon(isLoginSecure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        ConditionalBuilder(
                          condition: state is! OnLoadingLogin,
                          builder: (context) => defaultButton(
                              text: "تسجيل الدخول",
                              color: Colors.white,
                              background: defaultColor,
                              navigate: () async {
                                if (formKey.currentState!.validate()) {
                                  final result =
                                      await Connectivity().checkConnectivity();
                                  _showConnectivitySnackBar(result);
                                  cubit.login(
                                      phone: phoneController.text,
                                      password: passwordController.text);
                                }
                                if (state is LoginSuccessful) {
                                  navigateToFinish(
                                      context: context, widget: HomeLayout());
                                }
                              }),
                          fallback: (context) => SpinKitThreeBounce(
                            color: defaultColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      FittedBox(
                        child: Text(
                          "ليس لديك حساب ؟",
                          style: TextStyle(
                              fontSize: 18,
                              color:
                                  cubit.isDark ? Colors.white : Colors.black),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            navigateTo(
                                context: context, widget: RegisterScreen());
                          },
                          child: FittedBox(
                            child: Text(
                              "قم بإنشاء حساب",
                              style:
                                  TextStyle(fontSize: 18, color: defaultColor),
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: ismobile ? 10 : 30,
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: defaultColor,
                        ),
                      ),
                      Container(
                        color: cubit.isDark ? darkColor : Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "طريقه اخري لتسجيل",
                          style: TextStyle(
                              fontSize: ismobile ? 12 : 18,
                              color:
                                  cubit.isDark ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ismobile ? 20 : 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          Fluttertoast.showToast(
                              msg: "سيتم اضافة هذه الميزة قريبا");
                        },
                        child: SvgPicture.asset(
                          "assets/images/facebook.svg",
                          width: ismobile ? 30 : 40,
                          height: ismobile ? 30 : 40,
                        ),
                      ),
                      SizedBox(
                        width: ismobile ? 0 : 20,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Fluttertoast.showToast(
                              msg: "سيتم اضافة هذه الميزة قريبا");
                        },
                        child: SvgPicture.asset(
                          "assets/images/Google.svg",
                          width: ismobile ? 30 : 40,
                          height: ismobile ? 30 : 40,
                        ),
                      ),
                      SizedBox(
                        width: ismobile ? 0 : 20,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Fluttertoast.showToast(
                              msg: "سيتم اضافة هذه الميزة قريبا");
                        },
                        child: SvgPicture.asset(
                          "assets/images/Github.svg",
                          width: ismobile ? 30 : 40,
                          height: ismobile ? 30 : 40,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
