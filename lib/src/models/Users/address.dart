class Addresses {
  Addresses(
      {this.type = "",
      this.streetAddress = "",
      this.locality = "",
      this.region = "",
      this.postalCode = "",
      this.country = "",
      this.formatted = "",
      this.primary = true});

  String type;
  String streetAddress;
  String locality;
  String region;
  String postalCode;
  String country;
  String formatted;
  bool primary;

  factory Addresses.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final streetAddress = json['streetAddress'] as String;
    final locality = json['locality'] as String;
    final region = json['region'] as String;
    final postalCode = json['postalCode'] as String;
    final country = json['country'] as String;
    final formatted = json['formatted'] as String;
    final primary = json['primary'] as bool;

    return Addresses(
        type: type,
        streetAddress: streetAddress,
        locality: locality,
        region: region,
        postalCode: postalCode,
        country: country,
        formatted: formatted,
        primary: primary);
  }
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'streetAddress': streetAddress,
      'locality': locality,
      'region': region,
      'postalCode': postalCode,
      'country': country,
      'formatted': formatted,
      'primary': primary
    };
  }
}

