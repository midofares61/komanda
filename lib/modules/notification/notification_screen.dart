import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;
          return Scaffold(
            appBar: AppBar(
              actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
              title: Text("الاشعارات"),
            ),
            body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    "لا يوجد خدمات حتي الان",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: cubit.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                )
                // ListView.separated(
                //   physics: BouncingScrollPhysics(),
                //   separatorBuilder: (context, index) => Container(
                //     color: defaultColor,
                //     height: 1,
                //   ),
                //   itemCount: 25,
                //   itemBuilder: (context, index) => Container(
                //     padding: EdgeInsets.symmetric(vertical: 5),
                //     child: ListTile(
                //       leading: Stack(
                //         alignment: Alignment.center,
                //         children: [
                //           ClipOval(
                //             child: Container(
                //               width: 50,
                //               height: 50,
                //               color: Colors.blue[900],
                //             ),
                //           ),
                //           ClipOval(
                //             child: Container(
                //               height: 45,
                //               width: 45,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ],
                //       ),
                //       title: Text(
                //         "Mostafa",
                //         style: TextStyle(
                //             fontSize: 19,
                //             fontWeight: FontWeight.bold,
                //             color: cubit.isDark ? Colors.white : Colors.black),
                //       ),
                //       subtitle: Text(
                //         "Accepted",
                //         style: TextStyle(
                //             color: Colors.blue[700], fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ),
                // ),
                ),
          );
        });
  }
}
