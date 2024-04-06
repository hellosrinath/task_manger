class UserData {
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  String? photo;

  UserData(
      {this.email, this.firstName, this.lastName, this.mobile, this.photo});

  UserData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['mobile'] = this.mobile;
    data['photo'] = this.photo;
    return data;
  }

  String get fullName {
    return '${firstName ?? ''} ${lastName ?? ''}';
  }
}
