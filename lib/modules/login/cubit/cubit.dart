import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komanda/modules/login/cubit/states.dart';

import '../../../models/login_model.dart';
import '../../../models/register_model.dart';
import '../../../shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<ShopLoginStates>{
  LoginCubit():super(ShopLoginInitialState());

  static LoginCubit get(context)=>BlocProvider.of(context);

  LoginModel? loginModel;
  void login({required String phone, required String password}) async {
    emit(OnLoadingLogin());
    DioHelper.postData(
        url: "/sanctum/token",
        data: {"phone": phone, "password": password}).then((value) {
      loginModel = LoginModel.fromJson(value?.data);
      print(loginModel!.token);
      print(loginModel!.message);
      emit(LoginSuccessful());
    }).catchError((error) {
      print(error);
      emit(LoginError());
    });
  }

  List<dynamic>? logUnits;
  List<String> listUnits = [];
  void getLogUnits() async {
    listUnits=[];
    emit(OnLoadingGetLogunits());
    await DioHelper.getData(url: "/logUnits").then((value) {
      logUnits = value?.data;

      listUnits.addAll(logUnits!.map((dynamic item) => item.toString()));

      print("list ${listUnits.toString()}");

      emit(GetLogunitsSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetLogunitsError());
    });
  }

  List<dynamic>? logStories;
  List<String> listStories = [];
  void getLogStories() async {
    emit(OnLoadingGetLogStories());
    await DioHelper.getData(url: "/logStores").then((value) {
      logStories = value?.data;

      listStories.addAll(logStories!.map((dynamic item) => item.toString()));

      print("list ${listStories.toString()}");

      emit(GetLogStoriesSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetLogStoriesError());
    });
  }

  List<dynamic>? getPayNum;
  List<String> listPayNum = [];
  void getLogPayNum() async {
    emit(OnLoadingGetPayNum());
    await DioHelper.getData(url: "/get-pay").then((value) {
      getPayNum = value?.data;

      listPayNum.addAll(getPayNum!.map((dynamic item) => item.toString()));

      print("list ${listPayNum.toString()}");

      emit(GetPayNumSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetPayNumError());
    });
  }

  List<dynamic>? getCity;
  void getLocatioCity() async {
    emit(OnLoadingGetCity());
    await DioHelper.getData(url: "/get-city").then((value) {
      getCity = value?.data;
      emit(GetCitySuccessful());
    }).catchError((error) {
      print(error);
      emit(GetCityError());
    });
  }

  List<dynamic>? getLocation;
  void getLocatio({required String id}) async {
    emit(OnLoadingGetLocation());
    await DioHelper.getData(url: "/get-location", data: {"id": id})
        .then((value) {
      getLocation = value?.data;
      print(getLocation.toString());
      emit(GetLocationSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetLocationError());
    });
  }


}