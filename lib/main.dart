import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:komanda/shared/components/components.dart';
import 'package:komanda/shared/components/constance.dart';
import 'package:komanda/shared/network/local/chach_helper.dart';
import 'package:komanda/shared/network/remote/dio_helper.dart';
import 'package:komanda/shared/styles/colors.dart';

import 'cubit/bloc_observer.dart';
import 'cubit/cubit_app.dart';
import 'cubit/state_app.dart';
import 'layout/home_layout.dart';
import 'models/notification_model.dart';
import 'modules/login/cubit/cubit.dart';
import 'modules/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
  token = CacheHelper.getData(key: "token");
  await NotificationService.initNotification();
  runApp(MyApp(token));
}

class MyApp extends StatefulWidget {
  const MyApp(token, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return
        BlocProvider(create: (BuildContext context) => CubitApp()
          ..getLogUnits()
          ..getLogStories()
          ..getLogPayNum(),
        child: BlocConsumer<CubitApp, StateApp>(
            listener: (context, state) {
            },
            builder: (context, state) {
              return MaterialApp(
                  locale: const Locale("en"),
                  debugShowCheckedModeBanner: false,
                  theme: lightTheme,
                  title: 'كوماندا',
                  darkTheme: darkTheme,
                  themeMode: CacheHelper.getData(key: "isDark") != null
                      ? CacheHelper.getData(key: "isDark")
                          ? ThemeMode.dark
                          : ThemeMode.light
                      : ThemeMode.light,
                  home: SplashScreen());
            }));
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) => {
      navigateToFinish(context: context,widget:token != null ? HomeLayout() : LoginScreen())
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage("assets/images/splash_5.png")),
                ],
              ),
            ),
            Text("Powered by Sinatc Code",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}

