import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/network/remote/dio_helper.dart';
import 'chat_state.dart';

class CubitChat extends Cubit<ChatState> {
  CubitChat() : super(ChatInitialState());

  static CubitChat get(context) => BlocProvider.of(context);

  List<dynamic>? message;
  void sendMessage({
    required dynamic sender,
    required dynamic receiver,
    required String text,
  }) async {
    emit(OnLoadingGetMessage());
    await DioHelper.postData(
            url: "/massage",
            data: {"sender_id": sender, "chat_id": receiver, "text": text})
        .then((value) {
      message = value?.data;
      print(message!.toString());
      emit(GetMessageSuccessful());
    }).catchError((error) {
      print(error);
      emit(GetMessageError());
    });
  }
}
