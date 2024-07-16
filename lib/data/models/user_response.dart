// ignore_for_file: unnecessary_new, prefer_collection_literals

class UserResponse {
  String? token;
  User? user;

  UserResponse({this.token, this.user});

  UserResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? email;
  String? address;
  String? fullName;
  DateTime? birthDate;
  Enum? gender;
  String? id;

  User(
      {this.email,
      this.address,
      this.fullName,
      this.birthDate,
      this.gender,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    address = json['address'];
    fullName = json['fullName'];
    birthDate = json['birthDate'];
    gender = json['gender'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['address'] = this.address;
    data['fullName'] = this.fullName;
    data['birthDate'] = this.birthDate;
    data['gender'] = this.gender;
    data['id'] = this.id;
    return data;
  }
}
