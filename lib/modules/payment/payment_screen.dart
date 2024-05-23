import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komanda/modules/payment/withdraw.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'change_money.dart';
import 'deposite.dart';

class PaymentScreen extends StatelessWidget {
  final int value;
  PaymentScreen({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text("الرصيد"),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(image: AssetImage("assets/images/payment.png")),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "رصيدك",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            Spacer(),
                            Text(
                              "$value  جنية",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          navigateTo(
                              context: context, widget: WithdrawScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: cubit.isDark ? darkColor : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 10),
                              ]),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: [
                              Text(
                                "سحب",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.payments_sharp,
                                color:
                                    cubit.isDark ? Colors.white : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          navigateTo(
                              context: context, widget: DepositeScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: cubit.isDark ? darkColor : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 10),
                              ]),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: [
                              Text(
                                "ايداع",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.price_check,
                                color:
                                    cubit.isDark ? Colors.white : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          navigateTo(
                              context: context, widget: ChangeMoneyScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: cubit.isDark ? darkColor : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 10),
                              ]),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: [
                              Text(
                                "تحويل",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: cubit.isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.price_change,
                                color:
                                    cubit.isDark ? Colors.white : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
    ;
  }
}
