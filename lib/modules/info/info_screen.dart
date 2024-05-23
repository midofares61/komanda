import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:komanda/models/login_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../layout/home_layout.dart';
import '../../models/notification_model.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';
import '../infoKomanda/info_k_screen.dart';
import '../login/login_screen.dart';

class InfoScreeen extends StatelessWidget {
   InfoScreeen({super.key});

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
  @override
  Widget build(BuildContext context) {
    CubitApp.get(context).profilModel==null?CubitApp.get(context).getProfile(id: CacheHelper.getData(key: "UserId")):null;
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text("عن التطبيق"),
              ),
              body: ConditionalBuilder(
          condition: cubit.profilModel != null,
          builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(isDesktop ? 40 : 20),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          navigateToFinish(
                              context: context, widget: HomeLayout());
                          cubit.currentIndex = 4;
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: cubit.isDark ? darkColor : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 0),
                                    blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            children: [
                              Text(
                                "اعدادات الحساب",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color:
                                    cubit.isDark ? Colors.white : Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: cubit.isDark ? darkColor : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 0),
                                    blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(25)),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  navigateTo(
                                      context: context, widget: InfoKScreen());
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "نبذه عن كوماند",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: cubit.isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: (){
                                  NotificationService.showNotification(
                                      title: "تقييم البرنامج",
                                      body: " شكرا لك علي تقييم البرنامج");
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "تقيم  التطبيق",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: cubit.isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () async {
                                  String? encodeQueryParameters(
                                      Map<String, String> params) {
                                    return params.entries
                                        .map((MapEntry<String, String> e) =>
                                            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                        .join('&');
                                  }

                                  final Uri emailLaunchUri = Uri(
                                    scheme: 'mailto',
                                    path: 'comandacompany@gmail.com',
                                    query:
                                        encodeQueryParameters(<String, String>{
                                      'subject': 'ملاحضاتك حول تطبيق كوماندا',
                                    }),
                                  );
                                  if (await canLaunchUrl(emailLaunchUri)) {
                                    launchUrl(emailLaunchUri);
                                  } else {
                                    throw Exception(
                                        "could not lunch $emailLaunchUri");
                                  }
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "تبليغ عن مشكله",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: cubit.isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  Share.share(
                                      "مرحبا صديقي 👋 قم بتحميل تطبيق كوماند من خلال هذا الرابط https://kommanda.sintac.site/ لتستفيد بتوفير أفضل الفنيين في مختلف المهن او الحصول على عملائك بسهولة وشكل آمن ومضمون واستخدم كود الدعوة ( ${cubit.profilModel?.userId} ) لنتسفيد جميعا بربح النقود");
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "دعوة اصدقائك",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: cubit.isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.share,
                                      color: cubit.isDark
                                          ? Colors.white
                                          : Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          cubit.logOutUser(token: "${CacheHelper.getData(key: "token")}");
                          CacheHelper.removeData(key: "UserId");
                          CacheHelper.removeData(key: "token").then((value) {
                            cubit.loginModel=null;
                            cubit.profilModel=null;
                            if(value!){
                              navigateToFinish(
                                  context: context, widget: LoginScreen());
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: cubit.isDark ? darkColor : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 0),
                                    blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            children: [
                              Text(
                                "تسجيل الخروج",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.logout,
                                color:
                                    cubit.isDark ? Colors.white : Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
                fallback: (context)=>Center(
                  child: SpinKitThreeBounce(
                    color: defaultColor,
                    size: 30,
                  ),
                ),
              )
            ),
          );
        });
  }
}
