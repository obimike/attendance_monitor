class ClassDetails {
  final String? name;
  final String? classID;
  final String? cit;
  final String? cot;
  final List<dynamic>? days;

  ClassDetails({
    this.name,
    this.cit,
    this.cot,
    this.days,
    this.classID,
  });

  factory ClassDetails.fromJson(Map<String, dynamic> data) => ClassDetails(
    name: data['name'],
    cit: data['cit'],
    days: data['days'],
    cot: data['cot'],
    classID: data['classID'],
  );

  Map<String, dynamic> toJson() => {
    "days": days,
    "name": name,
    "cot": cot,
    "cit": cit,
    "classID": classID,
  };
}
