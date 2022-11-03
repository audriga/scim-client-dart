// @dart=2.9
import 'package:scim_client_dart/src/models/Users/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

class ScimClient {
  String serverUrl;
  String bearerToken;

  ScimClient(serverUrl, bearerToken) {
    if (!Uri.parse(serverUrl).isAbsolute) {
      throw Exception("Invalid serverUrl parameter <" + serverUrl + ">");
    }
    this.serverUrl = serverUrl;
    if (this.serverUrl.substring(this.serverUrl.length - 1) == '/') {
      this.serverUrl = this.serverUrl.substring(0, this.serverUrl.length - 1);
    }
    this.bearerToken = bearerToken;
    return;
  }

  Future<User> getUser(String id) async {
    if (id == null) {
      throw Exception("id is required field!");
    }
    var url = Uri.parse(serverUrl + '/Users' + '/' + id);
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/scim+json',
        HttpHeaders.authorizationHeader: 'Bearer ' + bearerToken
      },
    );

    if (response.statusCode != 200) {
      var statusCode = response.statusCode;
      print("HTTP ERROR! $statusCode.");
      print('User not found!');
      return null;
    } else {
      final responseJson = json.decode(response.body);
      var userDetails = User.fromJson(responseJson);
      print(json.encode(userDetails));
      return userDetails;
    }
  }

  Future<List<User>> getAllUsers() async {
    List<User> _list;
    var url = Uri.parse(serverUrl + '/Users');
    final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/scim+json',
        HttpHeaders.authorizationHeader: 'Bearer ' + bearerToken,
      },
    );

    if (response.statusCode != 200) {
      var statusCode = response.statusCode;
      print("HTTP ERROR! $statusCode.");
      print('Users cannot be retrived!');
      return null;
    } else {
      Map<String, dynamic> userMap = jsonDecode(response.body);
      var data = userMap["Resources"] as List;
      final Data = userMap["Resources"];
      _list = data.map<User>((json) => User.fromJson(json)).toList();
      _list.sort((a, b) {
        return a.userName.toLowerCase().compareTo(b.userName.toLowerCase());
      });
      for (var i = 0; i < Data.length; i++) {
        print(jsonEncode(_list[i]));
      }
      return (_list);
    }
  }

  Future<User> createUser(User user) async {
    if (user.userName == null || user.userName == null) {
      throw Exception('User Name is required field!');
    }
   
    String jsonUser = jsonEncode(user);
    var url = Uri.parse(serverUrl + '/Users');
    final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/scim+json',
        HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
      },
      body: jsonUser,
    );

    var statusCode = response.statusCode;

    if (statusCode == 201) {
      print(jsonDecode(response.body));
      return User.fromJson(jsonDecode(response.body));
    } else {
      print("HTTP ERROR! $statusCode.");
      print('Sorry, new User could not be created!');
      return null;
    }
  }

  Future<User> updateUser(User user) async {
    print(bearerToken);
    if ((user.id == null) || (user.id == null)) {
      throw Exception('User doesnot exist!');
    }
    var user_id = user.id;

    var url = Uri.parse(serverUrl + '/Users' + '/' + user_id);
    print(url);
    final userResponse = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/scim+json',
        HttpHeaders.authorizationHeader: 'Bearer ' + bearerToken
      },
    );
    if (userResponse.statusCode != 200) {
      var statusCode = userResponse.statusCode;
      print("HTTP ERROR! $statusCode.");
      print('User not found!');
      return null;
    }

    final responseJson = json.decode(userResponse.body);
    var userDetails = User.fromJson(responseJson);
    print(json.encode(userDetails));

    String jsonUser = jsonEncode(User(
      id: user.id,
      userName: (user.userName == null || user.userName == null)
          ? userDetails.userName
          : user.userName,
      externalId: (user.externalId == null || user.externalId == null)
          ? userDetails.externalId
          : user.externalId,
      profileUrl: (user.profileUrl == null || user.profileUrl == null)
          ? userDetails.profileUrl
          : user.profileUrl,
    ));
    var userData = json.encode(json.decode(jsonUser));
    final response = await http.put(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/scim+json',
        HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
      },
      body: userData,
    );

    var statusCode = response.statusCode;
    if (statusCode == 200) {
      print(jsonDecode(response.body));
      return User.fromJson(jsonDecode(response.body));
    } else {
      print("HTTP ERROR! $statusCode.");
      print('Sorry, User could not be updated!');
      return null;
    }
  }

  Future<bool> deleteUser(String id) async {
    if (id == null) {
      throw Exception("id is required field!");
    }
    var url = Uri.parse(serverUrl + '/Users' + '/' + id);
    final response = await http.delete(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/scim+json',
        HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
      },
    );

    var statusCode = response.statusCode;
    if (statusCode == 204) {
      String message = "User successfully deleted!";
      print(message);
      return true;
    } else {
      print("HTTP ERROR! $statusCode.");
      print('Sorry, User could not be deleted!');
      return false;
    }
  }
}
