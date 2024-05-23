class ProfileModel {
  dynamic id;
  String? name;
  String? userId;
  String? sendId;
  String? email;
  String? phone;
  String? img;
  String? ginder;
  String? plan;
  String? location;
  String? section;
  dynamic stars;
  dynamic val;

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["user_id"];
    sendId = json["send_id"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    img = json["img"];
    ginder = json["ginder"];
    plan = json["plan"];
    location = json["location"];
    stars = json["stars"];
    val = json["val"];
    section = json["section"];
  }
}
