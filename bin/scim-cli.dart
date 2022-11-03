// @dart=2.9
import 'package:scim_client_dart/scim_client.dart';
import 'package:path/path.dart' as path;
import 'package:args/args.dart';
import 'dart:io';
import 'dart:convert';

class HostAlias {
  var alias;
  var host;
  var token;

  HostAlias({this.alias, this.host, this.token});

  Map<String, dynamic> toJson() => {
        'alias': alias,
        'host': host,
        'token': token,
      };

  factory HostAlias.fromJson(Map<String, dynamic> data) {
    final alias = data['alias'] as String;
    final host = data['host'] as String;
    final token = data['token'] as String;
    var myAlias = HostAlias(alias: alias, host: host, token: token);

    return myAlias;
  }
}

ScimClient myScimClient;

Future addHostAlias(ArgResults argumentResults) async {
  if (argumentResults.command['alias'] == null) {
    throw Exception('--alias is required field');
  }
  if (argumentResults.command['host'] == null) {
    throw Exception('--host is required field');
  }
  if (argumentResults.command['token'] == null) {
    throw Exception('--token is required field');
  }

  String alias = argumentResults.command['alias'];
  String host = argumentResults.command['host'];
  String token = argumentResults.command['token'];

  HostAlias hostAlias = HostAlias(alias: alias, host: host, token: token);
  var jsonHostAlias = json.encode(hostAlias);

  await new File(path.absolute(Platform.environment['HOME']) + '/.scim-cli')
      .create(recursive: true);

  var myFile = File(path.absolute(Platform.environment['HOME']) + '/.scim-cli');
  var fileContents =
      await File(path.absolute(Platform.environment['HOME']) + '/.scim-cli')
          .readAsString();
  if (fileContents.length == 0) {
    var sink = myFile.openWrite();
    sink.write(jsonHostAlias);
    await sink.flush();
    await sink.close();
  } else {
    var contents = await myFile.readAsString();
    var jsonHostAliasList = jsonDecode('[' + contents + ']');

    List<HostAlias> hostAliasList;
    hostAliasList = jsonHostAliasList
        .map<HostAlias>((json) => HostAlias.fromJson(json))
        .toList();

    for (var i = 0; i < hostAliasList.length; i++) {
      if (alias == hostAliasList[i].alias) {
        throw Exception("The alias name already exists");
      }
    }

    var sink = myFile.openWrite(mode: FileMode.append);
    sink.write(', \n' + jsonHostAlias);
    await sink.flush();
    await sink.close();
  }
  print('Successfully added HostAlias!');
}

Future<HostAlias> getHostAlias(String alias) async {
  var myFile = File(path.absolute(Platform.environment['HOME']) + '/.scim-cli');
  var contents = await myFile.readAsString();
  var jsonHostAliasList = jsonDecode('[' + contents + ']');

  List<HostAlias> hostAliasList;
  hostAliasList = jsonHostAliasList
      .map<HostAlias>((json) => HostAlias.fromJson(json))
      .toList();

  var hostAlias = null;
  for (var i = 0; i < hostAliasList.length; i++) {
    if (alias == hostAliasList[i].alias) {
      hostAlias = hostAliasList[i];
      break;
    }
  }
  if (hostAlias == null) {
    throw Exception(
        "The alias doesn't match, please provide with correct alias or create a new one using addHostAlias");
  }
  var result = HostAlias(
      alias: hostAlias.alias, host: hostAlias.host, token: hostAlias.token);
  return result;
}

Future callGetUsers(ArgResults argumentResults) async {
  myScimClient.getAllUsers();
}

Future callGetUser(ArgResults argumentResults) async {
  var id = argumentResults.command['id'];
  myScimClient.getUser(id);
}

Future callCreateUser(ArgResults argumentResults) async {
  var userName = argumentResults.command['userName'];
  var profileUrl = argumentResults.command['profileUrl'];
  var externalId = argumentResults.command['externalId'];

  var user = User(
    userName: userName,
    externalId: externalId,
    profileUrl: profileUrl,
  );
  myScimClient.createUser(user);
}

Future callUpdateUser(ArgResults argumentResults) async {
  var id = argumentResults.command['id'];
  var userName = argumentResults.command['userName'];
  var profileUrl = argumentResults.command['profileUrl'];
  var externalId = argumentResults.command['externalId'];

  var user = User(
    id: id,
    userName: userName,
    externalId: externalId,
    profileUrl: profileUrl,
  );
  myScimClient.updateUser(user);
}

Future callDeleteUser(ArgResults argumentResults) async {
  var id = argumentResults.command['id'];
  myScimClient.deleteUser(id);
}

void main(List<String> args) async {
  var parser = ArgParser();
  var addHostAliasCmdParser = ArgParser();
  var getAllUsersCmdParser = ArgParser();
  var getUserCmdParser = ArgParser();
  var createUserCmdParser = ArgParser();
  var updateUserCmdParser = ArgParser();
  var deleteUserCmdParser = ArgParser();

  parser.addCommand('addHostAlias', addHostAliasCmdParser);
  addHostAliasCmdParser.addOption('alias');
  addHostAliasCmdParser.addOption('host');
  addHostAliasCmdParser.addOption('token');

  parser.addCommand('getAllUsers', getAllUsersCmdParser);
  getAllUsersCmdParser.addOption('hostalias');
  getAllUsersCmdParser.addOption('host');
  getAllUsersCmdParser.addOption('token');

  parser.addCommand('getUser', getUserCmdParser);
  getUserCmdParser.addOption('hostalias');
  getUserCmdParser.addOption('host');
  getUserCmdParser.addOption('token');
  getUserCmdParser.addOption('id');

  parser.addCommand('createUser', createUserCmdParser);
  createUserCmdParser.addOption('hostalias');
  createUserCmdParser.addOption('host');
  createUserCmdParser.addOption('token');
  createUserCmdParser.addOption('userName');
  createUserCmdParser.addOption('profileUrl');
  createUserCmdParser.addOption('externalId');

  parser.addCommand('updateUser', updateUserCmdParser);
  updateUserCmdParser.addOption('hostalias');
  updateUserCmdParser.addOption('host');
  updateUserCmdParser.addOption('token');
  updateUserCmdParser.addOption('id');
  updateUserCmdParser.addOption('userName');
  updateUserCmdParser.addOption('profileUrl');
  updateUserCmdParser.addOption('externalId');

  parser.addCommand('deleteUser', deleteUserCmdParser);
  deleteUserCmdParser.addOption('host');
  deleteUserCmdParser.addOption('hostalias');
  deleteUserCmdParser.addOption('token');
  deleteUserCmdParser.addOption('id');

  try {
    ArgResults argumentResults = parser.parse(args);
    argumentResults = parser.parse(args);

    String functionName = argumentResults.command.name;
    String host;
    String token;
    if (functionName != 'addHostAlias') {
      if (argumentResults.command['host'] != null ||
          argumentResults.command['token'] != null) {
        if (argumentResults.command['hostalias'] != null) {
          throw Exception(
              "Cannot use hostalias and host/token at the same time!!");
        }
        host = argumentResults.command['host'];
        token = argumentResults.command['token'];
      }
      if (argumentResults.command['hostalias'] != null) {
        var alias = await getHostAlias(argumentResults.command['hostalias']);
        host = alias.host;
        token = alias.token;
      }
      if (host == null || token == null) {
        throw Exception("No host or token found as an argument!");
      }

      myScimClient = ScimClient(host, token);
    }

    switch (functionName) {
      case 'addHostAlias':
        addHostAlias(argumentResults);
        break;
      case 'getAllUsers':
        callGetUsers(argumentResults);
        break;
      case 'getUser':
        callGetUser(argumentResults);
        break;
      case 'createUser':
        callCreateUser(argumentResults);
        break;
      case 'updateUser':
        callUpdateUser(argumentResults);
        break;
      case 'deleteUser':
        callDeleteUser(argumentResults);
        break;
      default:
        print('No function selected!');
        break;
    }
  } on FormatException catch (e) {
    print(e.message);
    print("--- usage:");
    print(addHostAliasCmdParser.usage);
    print(updateUserCmdParser.usage);
    print("---");
  }
}
