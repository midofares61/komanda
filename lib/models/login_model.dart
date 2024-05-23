class LoginModel {
  bool? status;
  String? message;
  String? token;
  UserModel? user;
  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["massage"];
    token = json["token"];
    user = UserModel.fromJson(json["user"]);
  }
}

class UserModel {
  dynamic id;
  dynamic name;
  dynamic userId;
  dynamic sendId;
  dynamic email;
  dynamic phone;
  dynamic img;
  dynamic ginder;
  dynamic plan;
  dynamic location;
  dynamic section;
  dynamic stars;
  dynamic val;
  dynamic status;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    userId = json["user_id"];
    sendId = json["send_id"];
    email = json["email"];
    phone = json["phone"];
    img = json["img"];
    ginder = json["ginder"];
    plan = json["plan"];
    location = json["location"];
    section = json["section"];
    stars = json["stars"];
    val = json["val"];
    status = json["status"];
  }
}

