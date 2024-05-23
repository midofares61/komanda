class RegisterModel {
  int? id;
  int? tokenId;
  String? name;
  String? token;
  RegisterModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    tokenId = json["tokenable_id"];
    name = json["name"];
    token = json["token"];
  }
}
