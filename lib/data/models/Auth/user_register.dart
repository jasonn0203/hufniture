class UserRegister {
  String? name;
  String? email;
  String? phoneNumber;
  String? password;
  String? confirmPassword;

  UserRegister(
      {this.name,
      this.email,
      this.phoneNumber,
      this.password,
      this.confirmPassword});

  UserRegister.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    return data;
  }
}
