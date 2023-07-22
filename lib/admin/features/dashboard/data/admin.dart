class Admin {
  final String? authKey;
  final String? fullName;
  final String? designation;
  final String? displayImage;
  final String? email;
  final String? role;
  final String? classID;
  final bool? hasClass;

  Admin({
    this.authKey,
    this.fullName,
    this.designation,
    this.displayImage,
    this.email,
    this.role,
    this.classID,
    this.hasClass,
  });

  factory Admin.fromJson(Map<String, dynamic> data) => Admin(
        authKey: data['authKey'],
        fullName: data['fullName'],
        designation: data['designation'],
        displayImage: data['displayImage'],
        email: data['email'],
        role: data['role'],
        classID: data['classID'],
        hasClass: data['hasClass'],
      );

  Map<String, dynamic> toJson() => {
        "authKey": authKey,
        "fullName": fullName,
        "email": email,
        "designation": designation,
        "displayImage": displayImage,
        "role": role,
        "classID": classID,
        "hasClass": hasClass,
      };
}
