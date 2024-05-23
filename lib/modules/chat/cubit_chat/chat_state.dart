abstract class ChatState {}

class ChatInitialState extends ChatState {}

class OnLoadingGetMessage extends ChatState {}

class GetMessageSuccessful extends ChatState {}

class GetMessageError extends ChatState {}
