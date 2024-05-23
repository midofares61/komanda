import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../shared/styles/colors.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  var searchController = TextEditingController();
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
                title: TextFormField(
                  autofocus: true,
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  textAlignVertical: TextAlignVertical.bottom,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    border: InputBorder.none,
                    hintText: "ابحث هنا",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              body: Center(
                child: Text("ستضاف هذه الميزة قريبا",style: TextStyle(fontSize: 20),),
              ),
            ),
          );
        });
  }
}
