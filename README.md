# SCIM-CLIENT-DART

[SCIM](http://www.simplecloud.info/) client library by [audriga](https://www.audriga.com) written in [Dart](https://dart.dev/)

---

# Table of Contents
1. [Info](#info)
1. [Capabilities](#capabilities)
1. [SCIM CLI](#scim-cli)
    1. [Info](#info-1)
    1. [Usage](#usage)
1. [Acknowledgements](#acknowledgements)

## Info

**scim-client-dart** is a Dart library which makes it easy to implement [SCIM v2.0](https://datatracker.ietf.org/wg/scim/documents/) clients.

It is built on the following IETF approved RFCs: [RFC7642](https://datatracker.ietf.org/doc/html/rfc7642), [RFC7643](https://datatracker.ietf.org/doc/html/rfc7643) and [RFC7644](https://datatracker.ietf.org/doc/html/rfc7644)

This is a **work in progress** project. It already works pretty well but some features will be added in the future and some bugs may still be around 😉

The **scim-client-dart** project currently includes the following:

* A SCIM 2.0 client core library
* An integrated CLI implementation

## Capabilities

This library provides:

* Standard SCIM resource *Core User* implementations
* Standard CRUD operations on the above SCIM resource
* An easily reusable code architecture for implementing SCIM clients

We plan to add support of other standard and custom SCIM resources soon

## SCIM CLI

### Info
* This is a proof-of-concept SCIM client CLI implementation
* You can use it for making basic CRUD operations on *Core User* resources on a SCIM v2.0 server
* It supports JWT authentication

### Usage

Call it with: `dart run bin/scim-cli.dart ...`

* Set the SCIM server URL/token to use: `dart run bin/scim-cli.dart --host my.scim.server.com --token jwt_token`
* Use SCIM server aliases
    * You can create aliases for your host/token combinations: `dart run bin/scim-cli.dart addHostAlias --alias my-server --host my.scim.server.com --token jwt_token`
    * You can use your aliases instead of specifying an server URL/token to use: `dart run bin/scim-cli.dart getUser --hostalias my-server ...`
    * Aliases are stored in `~/.scim-cli`
* Read all users: `dart run bin/scim-cli.dart getAllUsers --hostalias my-server`
* Read one user: `dart run bin/scim-cli.dart getUser --hostalias my-server --id user_id`
* Create a user: `dart run bin/scim-cli.dart createUser --hostalias my-server --userName user_name --profileUrl user_profile --externalId user_id`
    * Note that only `userName`, `profileUrl` and `externalId` properties are supported for now
    * We will enhance the user creation feature soon
* Update a user: `dart run bin/scim-cli.dart updateUser --hostalias my-server --id user_id --userName new_user_name --profileUrl new_user_profile --externalId new_external_id`
* Delete a user: `dart run bin/scim-cli.dart deleteUser --hostalias my-server --id user_id`

## Acknowledgements

This software is part of the [Open Provisioning Framework](https://www.audriga.com/en/User_provisioning/Open_Provisioning_Framework) project that has received funding from the European Union's Horizon 2020 research and innovation program under grant agreement No. 871498.