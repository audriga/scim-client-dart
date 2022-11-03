import 'dart:convert';

Name NameFromJson(String str) => Name.fromJson(json.decode(str));

class Name {
  String? formatted;
  String? familyName;
  String? givenName;
  String? middleName;
  String? honorificPrefix;
  String? honorificSuffix;

  Name({
    this.formatted = "",
    this.familyName = "",
    this.givenName = "",
    this.middleName = "",
    this.honorificPrefix = "",
    this.honorificSuffix = "",
  });

  factory Name.fromJson(Map<String, dynamic> data) {
    final formatted = data['formatted'] as String;
    final familyName = data['familyName'] as String;
    final givenName = data['givenName'] as String;
    final middleName = data['middleName'] as String;
    final honorificPrefix = data['honorificPrefix'] as String;
    final honorificSuffix = data['honorificSuffix'] as String;

    var myName = Name(
      formatted: formatted,
      familyName: familyName,
      givenName: givenName,
      middleName: middleName,
      honorificPrefix: honorificPrefix,
      honorificSuffix: honorificSuffix,
    );

    return myName;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> Name = <String, dynamic>{};

    Name['formatted'] = formatted;
    Name['familyName'] = familyName;
    Name['givenName'] = givenName;
    Name['middleName'] = middleName;
    Name['honorificPrefix'] = honorificPrefix;
    Name['honorificSuffix'] = honorificSuffix;

    return Name;
  }
}
