class MyUser{
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String city;
  final String uid;
  final String gender;
  final String foundApp;
  final String currentPermission;

  const MyUser({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.city,
    required this.uid,
    required this.gender,
    required this.foundApp,
     this.currentPermission = '0', // Permission 0 means regular user (no special permissions), Permission 1 means admin permissions.
  });

    static MyUser fromJson(json) => MyUser(
    firstName: json['firstName'],
    lastName: json['lastName'],
    phoneNumber: json['phoneNumber'],
    city: json['city'],
    uid: json['uid'],
    gender: json['gender'],
    foundApp: json['foundApp'],
    currentPermission: json['currentPermission'],
  );

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'city': city,
      'uid': uid,
      'gender': gender,
      'foundApp': foundApp,
      'currentPermission': currentPermission,
    };
  }

}