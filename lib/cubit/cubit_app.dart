import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:komanda/cubit/state_app.dart';
import 'package:sqflite/sqflite.dart';

import '../models/login_model.dart';
import '../models/profile_model.dart';
import '../models/register_model.dart';
import '../modules/home/home_screen.dart';
import '../modules/notification/notification_screen.dart';
import '../modules/order/order_screen.dart';
import '../modules/profile/profile_screen.dart';
import '../modules/setting/setting_screen.dart';
import '../shared/network/local/chach_helper.dart';
import '../shared/network/remote/dio_helper.dart';

class CubitApp extends Cubit<StateApp> {
  CubitApp() : super(AppInitialState());

  static CubitApp get(context) => BlocProvider.of(context);

  var currentIndex = 0;

  var isDark = CacheHelper.getData(key: "isDark") != null
      ? CacheHelper.getData(key: "isDark")
      : false;

  void changeMode({required bool value}) {
    isDark = value;
    CacheHelper.SaveData(key: "isDark", value: value);
    emit(ChangeThemeModeState());
  }
  void changeindex(int index) {
    currentIndex = index;
    emit(ChangeIndexBottomState());
  }

  List<Widget> screen = [
    HomeScreen(),
    ProfileScreen(),
    NotificationScreen(),
    OrderScreen(),
    SettingScreen(),
  ];

  List<BottomNavigationBarItem> bottomItem = [
    BottomNavigationBarItem(
        icon: Icon(
          Icons.home,
        ),
        label: "الرئيسية"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.chat,
        ),
        label: "المحادثات"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.person,
        ),
        label: "ملفي"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.notifications,
        ),
        label: "الاشعارات"),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.settings,
        ),
        label: "الضيط"),
  ];

  ProfileModel? profilModel;

  void getProfile({required dynamic id}) async {
    emit(OnLoadingGetProfile());
    DioHelper.getData(url: "/user/id", data: {"id": id}).then((value) {
      profilModel = ProfileModel.fromJson(value?.data);
      print(value?.data);
      emit(GetProfileSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetProfileError());
    });
  }

  List<dynamic>? section;
  void getSection() async {
    emit(OnLoadingGetSection());
    await DioHelper.getData(url: "/sections").then((value) {
      section = value?.data;
      print(section![0].toString());
      emit(GetSectionSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetSectionError());
    });
  }

  List<dynamic>? stories;
  void getStories() async {
    emit(OnLoadingGetStories());
    await DioHelper.getData(url: "/stores").then((value) {
      stories = value?.data;
      print(stories![0]["name"].toString());
      emit(GetStoriesSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetStoriesError());
    });
  }

  List<dynamic>? units;
  void getUnits({required dynamic id}) async {
    emit(OnLoadingGetUnits());
    await DioHelper.getData(url: "/units", data: {"id": id}).then((value) {
      units = value?.data;
      print(units!.toString());
      emit(GetUnitsSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetUnitsError());
    });
  }

  List<dynamic>? mans;
  void getMans({required dynamic name}) async {
    emit(OnLoadingGetMans());
    await DioHelper.getData(url: "/man", data: {"id": name}).then((value) {
      mans = value?.data;
      print(mans!.toString());
      emit(GetMansSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetMansError());
    });
  }

  List<dynamic>? chats;
  void getChats({
    required dynamic sender,
    required dynamic receiver,
    required dynamic userId,
  }) async {
    emit(OnLoadingGetChats());
    await DioHelper.getData(url: "/chat", data: {
      "sender_id": sender,
      "receiver_id": receiver,
      "user_id": userId,
    }).then((value) {
      chats = value?.data;
      print(chats![0]["text"]);
      emit(GetChatsSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetChatsError());
    });
  }

  List<dynamic>? message;
  void sendMessage({
    required dynamic sender,
    required dynamic receiver,
    required String? text,
    required String? image,
  }) async {
    emit(OnLoadingGetMessage());
    await DioHelper.postData(url: "/massage", data: {
      "sender_id": sender,
      "chat_id": receiver,
      "text": text,
      "img": image
    }).then((value) {
      message = value?.data;
      print(message!.toString());
      emit(GetMessageSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetMessageError());
    });
  }

  List<dynamic>? order;
  void getOrders({
    required dynamic id,
  }) async {
    emit(OnLoadingGetOrders());
    await DioHelper.getData(url: "/chatsSend", data: {
      "receiver_id": id,
    }).then((value) {
      order = value?.data;
      print(order!.toString());
      emit(GetOrdersSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetOrdersError());
    });
  }

  List<dynamic>? chatReceiv;
  void getChatReceiv({
    required dynamic id,
  }) async {
    emit(OnLoadingGetChatReceiv());
    await DioHelper.getData(url: "/chatsResev", data: {
      "receiver_id": id,
    }).then((value) {
      chatReceiv = value?.data;
      print(chatReceiv!.toString());
      emit(GetChatReceivSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetChatReceivError());
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

  List<dynamic>? logUnits;
  List<String> listUnits = [];
  void getLogUnits() async {
    listUnits=[];
    emit(OnLoadingGetLogunits());
    await DioHelper.getData(url: "/logUnits").then((value) {
      logUnits = value?.data;

      listUnits.addAll(logUnits!.map((dynamic item) => item.toString()));

      print("list Units ${listUnits.toString()}");

      emit(GetLogunitsSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetLogunitsError());
    });
  }

  List<dynamic>? logStories;
  List<String> listStories = [];
  void getLogStories() async {
    listStories=[];
    emit(OnLoadingGetLogStories());
    await DioHelper.getData(url: "/logStores").then((value) {
      logStories = value?.data;

      listStories.addAll(logStories!.map((dynamic item) => item.toString()));

      print("list Stories ${listStories.toString()}");

      emit(GetLogStoriesSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetLogStoriesError());
    });
  }

  String? messageDeposite;
  void deposit({
    required dynamic total,
    required dynamic resentNum,
    required dynamic resiveNum,
    required dynamic userId,
    required String image,
  }) async {
    emit(OnLoadingDeposite());
    await DioHelper.postData(url: "/send-price", data: {
      "total": total,
      "resnt_num": resentNum,
      "resiv_num": resiveNum,
      "user_id": userId,
      "img": image,
    }).then((value) {
      messageDeposite = value?.data;
      print(messageDeposite!.toString());
      emit(DepositeSuccessful());
    }).catchError((error) {
      print(error);
      emit(DepositeError());
    });
  }

  String? messageWithdraw;
  void withdraw({
    required dynamic total,
    required dynamic resiveNum,
    required dynamic userId,
  }) async {
    emit(OnLoadingWithdraw());
    await DioHelper.postData(url: "/resiv-price", data: {
      "total": total,
      "resiv_num": resiveNum,
      "user_id": userId,
    }).then((value) {
      messageWithdraw = value?.data;
      print(value?.data.toString());
      emit(WithdrawSuccessful());
    }).catchError((error) {
      print(error.toString());
      emit(WithdrawError());
    });
  }

  String? messageConvert;
  void convert({
    required dynamic total,
    required dynamic resiveNum,
    required dynamic userId,
    required dynamic userNum,
  }) async {
    emit(OnLoadingConvert());
    await DioHelper.postData(url: "/con-price", data: {
      "total": total,
      "resiv_num": resiveNum,
      "user_id": userId,
      "user_num": userNum,
    }).then((value) {
      messageConvert = value?.data;
      print(messageConvert!.toString());
      emit(ConvertSuccessful());
    }).catchError((error) {
      print(error);
      emit(ConvertError());
    });
  }

  String? sendImageMessage;
  void sendImageToGallery({
    required dynamic userId,
    required String img,
  }) async {
    emit(OnLoadingSendImage());
    await DioHelper.postData(url: "/send-post", data: {
      "user_id": userId,
      "img": img,
    }).then((value) {
      sendImageMessage = value?.data;
      print(sendImageMessage!.toString());
      emit(SendImageSuccessful());
    }).catchError((error) {
      print(error);
      emit(SendImageError());
    });
  }

  List<dynamic>? getProfileImage;
  void getprofileImage({required int id}) async {
    emit(OnLoadingGetProfileImage());
    await DioHelper.getData(url: "/get-posts", data: {"user_id": id})
        .then((value) {
      getProfileImage = value?.data;
      print(getProfileImage.toString());
      emit(GetProfileImageSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetProfileImageError());
    });
  }

  String? editProfile;
  void EditProfile({
    required dynamic userId,
    String? location,
    String? jop,
    String? gender,
  }) async {
    emit(OnLoadingEditProfile());
    await DioHelper.getData(url: "/c-update", data: {
      "id": userId,
      "location": location,
      "section": jop,
      "ginder": gender,
    }).then((value) {
      editProfile = value?.data;
      print(editProfile!.toString());
      emit(EditProfileSuccessful());
    }).catchError((error) {
      print(error);
      emit(EditProfileError());
    });
  }

  String? codeVerification;
  void getCodeVerification({required String code,required int id}) async {
    emit(OnLoadingGetCodeVerification());
    await DioHelper.getData(url: "/send-code", data: {"id":id,"user_id": code})
        .then((value) {
      codeVerification = value?.data;
      print(codeVerification.toString());
      emit(GetCodeVerificationSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetCodeVerificationError());
    });
  }

  String? logOut;
  void logOutUser({required String token}) async {
    emit(OnLoadingLogout());
    await DioHelper.getData(url: "/user/revoke", data: {"token":token,})
        .then((value) {
      logOut = value?.data;
      print(logOut.toString());
      emit(LogoutSuccessful());
    }).catchError((error) {
      print(error);
      emit(LogoutError());
    });
  }

  late Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archiveTasks=[];
  void createDatabase()  {
    openDatabase("komanda.db", version: 1,
        onCreate: (database, version) {
          print("Database Created");
          database
              .execute(
              "CREATE TABLE profile (id INTEGER PRIMARY KEY,tokenId INTEGER,name TEXT,userId TEXT,sendId TEXT,email TEXT,phone TEXT,img TEXT,ginder TEXT,plan TEXT,location TEXT,section TEXT,stars INTEGER,val INTEGER,status TEXT)")
              .then((value) {
            print("tabel created");
          }).catchError((error) {
            print("error when create table ${error.toString()}");
          });
        }, onOpen: (database) {
          getDtatFromDatabase(database);
          print("Database Opend");
        }).then((value) {
      database=value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required int tokenId,
    required String name,
    required String userId,
    required String sendId,
    required String email,
    required String status,
    required String phone,
    required String img,
    required String ginder,
    required String plan,
    required String location,
    required String section,
    required int stars,
    required int val,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
          'INSERT INTO profile(tokenId, name, userId,sendId,email,phone,img,ginder,plan,location,section,stars,val,status) VALUES("$tokenId", "$name", "$userId","$sendId","$email","$phone","$img","$ginder","$plan","$location","$section","$stars","$val","$status")')
          .then((value) {
        print("$value value inserting");
        emit(AppInsertDatabaseState());
        getDtatFromDatabase(database);
      }).catchError((error) {
        print("Error in Insert database ${error.toString()}");
      });
      return Future(() => null);
    });
  }

  void getDtatFromDatabase(database) {
    newTasks=[];

    emit(AppGetDatabaseState());
    database.rawQuery('SELECT * FROM profile').then((value) {
      value.forEach((element)
      {
          newTasks.add(element);
      }
      );
      emit(AppGetDatabaseState());
    });
  }
  void updateData({
    required var status,
    required int id,
  }){
    database.rawUpdate(
      'UPDATE profile SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value){
      getDtatFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }
  void deleteData({
    required int id,
  }) {
    database.rawDelete('DELETE FROM profile WHERE id = ?', [id]).then((value) {
      getDtatFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

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

  RegisterModel? registerModel;
  void registration({
    required String name,
    required String email,
    required String phone,
    required String ginder,
    required String section,
    required String plan,
    required String location,
    required String password,
  }) async {
    emit(OnLoadingRegistration());
    await DioHelper.postData(url: "/sanctum/signUp", data: {
      "name": name,
      "email": email,
      "phone": phone,
      "ginder": ginder,
      "section": section,
      "plan": plan,
      "location": location,
      "password": password,
    }).then((value) {
      registerModel = RegisterModel.fromJson(value?.data);
      print(registerModel?.token);
      emit(RegistrationSuccessful());
    }).catchError((error) {
      print(error);
      emit(RegistrationError());
    });
  }
}

