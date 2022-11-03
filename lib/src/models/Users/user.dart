import 'dart:convert';
import 'name.dart';
import 'multiValuesAttribute.dart';
import 'address.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

class User {
  String id;
  String externalId;
  String location;
  String userName;
  Name? name;
  Object meta;
  String displayName;
  String nickName;
  String profileUrl;
  String title;
  String userType;
  String preferredLanguage;
  String locale;
  String timezone;
  bool active;
  String password;
  List<MultiValuesAttribute> emails;
  List<MultiValuesAttribute> phoneNumbers;
  List<Addresses> addresses;
  List<MultiValuesAttribute> ims;
  List<MultiValuesAttribute> photos;
  List<MultiValuesAttribute> groups;

  User({
    this.id = "",
    this.externalId = "",
    this.location = "",
    required this.userName,
    this.name = null,
    this.meta = "",
    this.displayName = "",
    this.nickName = "",
    this.profileUrl = "",
    this.title = "",
    this.userType = "",
    this.preferredLanguage = "",
    this.locale = "",
    this.timezone = "",
    this.active = true,
    this.password = "",
    this.emails = const [],
    this.phoneNumbers = const [],
    this.addresses = const [],
    this.ims = const [],
    this.photos = const [],
    this.groups = const [],
  });

  factory User.fromJson(Map<String, dynamic> data) {
    final id = data['id'] as String;
    final externalId = data['externalId'] as String;
    final location = data['location'] as String;
    final userName = data['userName'] as String;
    final name = data['name'] == null ? null : Name.fromJson(data['name']);
    final meta = data['meta'] as Object;
    final displayName = data['displayName'] as String;
    final nickName = data['nickName'] as String;
    final profileUrl = data['profileUrl'] as String;
    final title = data['title'] as String;
    final userType = data['userType'] as String;
    final preferredLanguage = data['preferredLanguage'] as String;
    final locale = data['locale'] as String;
    final timezone = data['timezone'] as String;
    final active = data['active'] as bool;
    final password = data['password'] as String;
    final emails = data['emails'] as List<MultiValuesAttribute>;
    final phoneNumbers = data['phoneNumbers'] as List<MultiValuesAttribute>;
    final addresses = data['addresses'] as List<Addresses>;
    final ims = data['ims'] as List<MultiValuesAttribute>;
    final photos = data['photos'] as List<MultiValuesAttribute>;
    final groups = data['groups'] as List<MultiValuesAttribute>;

    var myUser = User(
        id: id,
        externalId: externalId,
        location: location,
        userName: userName,
        name: name,
        meta: meta,
        displayName: displayName,
        nickName: nickName,
        profileUrl: profileUrl,
        title: title,
        userType: userType,
        preferredLanguage: preferredLanguage,
        locale: locale,
        timezone: timezone,
        active: active,
        password: password,
        emails: emails,
        phoneNumbers: phoneNumbers,
        addresses: addresses,
        ims: ims,
        photos: photos,
        groups: groups);

    return myUser;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};

    user['id'] = id;
    user['externalId'] = externalId;
    user['location'] = location;
    user['userName'] = userName;
    user['name'] = name;
    user['meta'] = meta;
    user['displayName'] = displayName;
    user['nickName'] = nickName;
    user['profileUrl'] = profileUrl;
    user['title'] = title;
    user['userType'] = userType;
    user['preferredLanguage'] = preferredLanguage;
    user['locale'] = locale;
    user['timezone'] = timezone;
    user['active'] = active;
    user['password'] = password;
    user['emails'] = emails;
    user['phoneNumbers'] = phoneNumbers;
    user['addresses'] = addresses;
    user['ims'] = ims;
    user['photos'] = photos;

    return user;
  }
}
