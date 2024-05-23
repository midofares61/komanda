import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../cubit/cubit_app.dart';
import '../../cubit/state_app.dart';
import '../../shared/components/components.dart';
import '../../shared/network/local/chach_helper.dart';
import '../../shared/styles/colors.dart';
import 'image_chat.dart';

class ChatScreen extends StatefulWidget {
  final dynamic id;
  final dynamic sender;
  final String name;
  final String image;
  ChatScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.sender,
      required this.image});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var chatController = TextEditingController();
  File? _selectImage;
  File? _compressImage;
  String? imageSend;
  IO.Socket? _socket;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // connect();
    // _connectScocketChannel();
  }

  // void connect() {
  //   _socket = IO.io("");
  //   _socket?.connect();
  //   _socket?.onconnect((data) => print("Connected"));
  // }

  // _connectScocketChannel() {
  //   _channel = IOWebSocketChannel.connect("wss://echo.websocket.events");
  // }

  // void sendMessage() {
  //   _channel!.sink.add(chatController.text);
  // }

  // @override
  // void disopse() {
  //   super.dispose();
  //   _channel!.sink.close();
  // }

  @override
  Widget build(BuildContext context) {
    CubitApp.get(context).chats = null;
    CubitApp.get(context).getChats(
        sender: widget.sender,
        receiver: widget.id,
        userId: CacheHelper.getData(key: "UserId"));
    return BlocConsumer<CubitApp, StateApp>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CubitApp.get(context);
          final isDesktop = MediaQuery.of(context).size.width >= 500;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: cubit.isDark ? darkColor : Colors.white,
              iconTheme: IconThemeData(
                  color: cubit.isDark ? Colors.white : defaultColor),
              title: Row(
                children: [
                  Container(
                      decoration: BoxDecoration(

                          borderRadius:
                          BorderRadius.circular(100)),
                      clipBehavior: Clip.antiAlias,
                      child: Image.memory(
                    base64Decode("${widget.image}"),
                    width: 40,
                    height: 40,
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      "${widget.name}",
                      style: TextStyle(
                          color: cubit.isDark ? Colors.white : defaultColor,
                          fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl,
                    ),
                  )
                ],
              ),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ConditionalBuilder(
                      condition: cubit.chats != null,
                      builder: (context) => Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await Future.delayed(Duration(seconds: 1));
                                CubitApp.get(context).getChats(
                                    sender: widget.sender,
                                    receiver: widget.id,
                                    userId: CacheHelper.getData(key: "UserId"));
                                setState(() {});
                              },
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                reverse: true,
                                itemBuilder: (context, index) => Container(
                                  child:
                                      cubit.chats![index]["sender_id"] ==
                                              CacheHelper.getData(key: "UserId")
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 90),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  cubit.chats![index]["text"] !=
                                                              null &&
                                                          cubit.chats![index]
                                                                  ["img"] !=
                                                              null
                                                      ? Stack(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .topEnd,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          defaultColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          navigateTo(
                                                                              context: context,
                                                                              widget: ImageChat(image: cubit.chats![index]["img"]));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              300,
                                                                          child:
                                                                              Image.memory(
                                                                            base64Decode(cubit.chats![index]["img"]),
                                                                            height:
                                                                                300,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      SelectableText(
                                                                        cubit.chats![index]
                                                                            [
                                                                            "text"],
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                            Container(
                                                              width: 20,
                                                              height: 10,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      defaultColor,
                                                                  borderRadius:
                                                                      BorderRadius.only(
                                                                          bottomRight:
                                                                              Radius.circular(25))),
                                                            )
                                                          ],
                                                        )
                                                      : cubit.chats![index]
                                                                  ["text"] !=
                                                              null
                                                          ? Stack(
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .topEnd,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5),
                                                                  child: Container(
                                                                      decoration: BoxDecoration(color: defaultColor, borderRadius: BorderRadius.circular(5)),
                                                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                                      child: Column(
                                                                        children: [
                                                                          SelectableText(
                                                                            cubit.chats![index]["text"],
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ),
                                                                Container(
                                                                  width: 20,
                                                                  height: 10,
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          defaultColor,
                                                                      borderRadius:
                                                                          BorderRadius.only(
                                                                              bottomRight: Radius.circular(25))),
                                                                )
                                                              ],
                                                            )
                                                          : cubit.chats![index]
                                                                      ["img"] !=
                                                                  null
                                                              ? Stack(
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .topEnd,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5),
                                                                      child: Container(
                                                                          decoration: BoxDecoration(color: defaultColor, borderRadius: BorderRadius.circular(5)),
                                                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                          child: Column(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  navigateTo(context: context, widget: ImageChat(image: cubit.chats![index]["img"]));
                                                                                },
                                                                                child: Container(
                                                                                  width: 300,
                                                                                  child: Image.memory(
                                                                                    base64Decode(cubit.chats![index]["img"]),
                                                                                    height: 300,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )),
                                                                    ),
                                                                    Container(
                                                                      width: 20,
                                                                      height:
                                                                          10,
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              defaultColor,
                                                                          borderRadius:
                                                                              BorderRadius.only(bottomRight: Radius.circular(25))),
                                                                    )
                                                                  ],
                                                                )
                                                              : const SizedBox(),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 90),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  cubit.chats![index]["text"] !=
                                                              null &&
                                                          cubit.chats![index]
                                                                  ["img"] !=
                                                              null
                                                      ? Stack(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .topStart,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                              .grey[
                                                                          300],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          navigateTo(
                                                                              context: context,
                                                                              widget: ImageChat(image: cubit.chats![index]["img"]));
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              300,
                                                                          child:
                                                                              Image.memory(
                                                                            base64Decode(cubit.chats![index]["img"]),
                                                                            height:
                                                                                300,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      SelectableText(
                                                                        cubit.chats![index]
                                                                            [
                                                                            "text"],
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                            Container(
                                                              width: 20,
                                                              height: 10,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                          .grey[
                                                                      300],
                                                                  borderRadius:
                                                                      BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(25))),
                                                            )
                                                          ],
                                                        )
                                                      : cubit.chats![index]
                                                                  ["text"] !=
                                                              null
                                                          ? Stack(
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .topStart,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5),
                                                                  child: Container(
                                                                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5)),
                                                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                                                      child: Column(
                                                                        children: [
                                                                          SelectableText(
                                                                            cubit.chats![index]["text"],
                                                                            style:
                                                                                TextStyle(color: Colors.black),
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                          ),
                                                                        ],
                                                                      )),
                                                                ),
                                                                Container(
                                                                  width: 20,
                                                                  height: 10,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                              .grey[
                                                                          300],
                                                                      borderRadius:
                                                                          BorderRadius.only(
                                                                              bottomLeft: Radius.circular(25))),
                                                                )
                                                              ],
                                                            )
                                                          : cubit.chats![index]
                                                                      ["img"] !=
                                                                  null
                                                              ? Stack(
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .topStart,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5),
                                                                      child: Container(
                                                                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5)),
                                                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                          child: Column(
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  navigateTo(context: context, widget: ImageChat(image: cubit.chats![index]["img"]));
                                                                                },
                                                                                child: Container(
                                                                                  width: 300,
                                                                                  child: Image.memory(
                                                                                    base64Decode(cubit.chats![index]["img"]),
                                                                                    height: 300,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )),
                                                                    ),
                                                                    Container(
                                                                      width: 20,
                                                                      height:
                                                                          10,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.grey[
                                                                              300],
                                                                          borderRadius:
                                                                              BorderRadius.only(bottomLeft: Radius.circular(25))),
                                                                    )
                                                                  ],
                                                                )
                                                              : const SizedBox(),
                                                ],
                                              ),
                                            ),
                                ),
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 10,
                                ),
                                itemCount: cubit.chats!.length,
                              ),
                            ),
                          ),
                      fallback: (context) =>
                          Center(child: SpinKitThreeBounce(
                            color: defaultColor,
                            size: 30,
                          ))),
                ),
                _selectImage != null
                    ? Container(
                        width: double.infinity,
                        color: Colors.grey[300],
                        padding: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Image.file(
                            _selectImage!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox(),
                if (state is OnLoadingGetChats)
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: defaultColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: Icon(
                                      Icons.timer_sharp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: defaultColor,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(25))),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: cubit.isDark ? darkColor : Colors.white,
                  width: double.infinity,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _picImageFromGallery();
                        },
                        icon: Icon(Icons.image,
                            color: cubit.isDark ? Colors.white : Colors.black),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          child: TextFormField(
                            textDirection: TextDirection.rtl,
                            controller: chatController,
                            keyboardType: TextInputType.text,
                            textAlignVertical: TextAlignVertical.bottom,
                            cursorColor: defaultColor,
                            maxLines: 4,
                            minLines: 1,
                            style: TextStyle(
                                color:
                                    cubit.isDark ? Colors.white : Colors.black),
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: cubit.isDark
                                            ? Colors.white
                                            : Colors.black)),
                                hintText: _selectImage != null
                                    ? "اضف شرح"
                                    : "اكتب رسالة",
                                isCollapsed: true,
                                contentPadding: EdgeInsets.all(5)),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (!chatController.text.isEmpty ||
                                imageSend != null) {
                              cubit.sendMessage(
                                sender: CacheHelper.getData(key: "UserId"),
                                receiver: cubit.chats![0]["chat_id"],
                                text: !chatController.text.isEmpty
                                    ? chatController.text
                                    : null,
                                image: imageSend,
                              );
                              print(imageSend);
                              chatController.text = "";
                              _selectImage = null;
                              imageSend = null;
                              cubit.getChats(
                                  sender: widget.sender,
                                  receiver: widget.id,
                                  userId: CacheHelper.getData(key: "UserId"));
                            }
                          },
                          icon: Icon(
                            Icons.send,
                            color: cubit.isDark ? Colors.white : defaultColor,
                          ))
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future _picImageFromGallery() async {
    final XFile? returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;

    final image = File(returnImage.path);
    if (!image.existsSync()) return; // التحقق من وجود الصورة

    setState(() {
      _selectImage = image;
      print("_selectImage$_selectImage");
      compress(image);
    });
  }

  Future convertImage(File image) async {
    Uint8List imageBytes = await image.readAsBytes();
    String base64string = base64.encode(imageBytes);
    setState(() {
      imageSend = base64string;
      print("convertImage$imageSend");
      print(imageSend);
    });
  }

  Future<void> compress(File _selectImage) async {
    print("_selectImage compress${_selectImage.path}");
    if (_selectImage == null) {
      // إذا كان _selectImage هو null، قم بإيقاف تنفيذ الدالة
      return print("null");
    }

    var result = await FlutterImageCompress.compressAndGetFile(
      _selectImage.path,
      '/data/user/0/com.example.komanda/compress.jpg',
      quality: 5,
    );
    print("result$result");
    if (result == null) {
      // إذا كان result هو null، قم بإيقاف تنفيذ الدالة
      return print("result=null");
    }

    setState(() {
      _compressImage = File(result.path);
      print("_compressImage$_compressImage");
      convertImage(_compressImage!);
    });
  }
}
