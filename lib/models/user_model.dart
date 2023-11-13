class User {
  String? app;
  String? firstName;
  String? lastName;
  String? profilePicture;
  String? email;
  String? role;
  bool? verified;
  String? country;
  String? gender;
  String? phoneNumber;
  String? sId;

  User({
    this.app,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.email,
    this.role,
    this.verified,
    this.country,
    this.gender,
    this.phoneNumber,
    this.sId,
  });

  User.fromJson(Map<String, dynamic> json) {
    app = json['app'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePicture = json['profilePicture'];
    email = json['email'];
    role = json['role'];
    verified = json['verified'];
    country = json['country'];
    gender = json['gender'];
    phoneNumber = json['phoneNumber'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app'] = app;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['profilePicture'] = profilePicture;
    data['email'] = email;
    data['role'] = role;
    data['verified'] = verified;
    data['country'] = country;
    data['phoneNumber'] = phoneNumber;
    data['_id'] = sId;
    return data;
  }
}
