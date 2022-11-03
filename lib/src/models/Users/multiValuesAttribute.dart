class MultiValuesAttribute {
  MultiValuesAttribute({this.value = "", this.primary = null, this.type = null, this.display = null, this.ref = null});

  String value;
  String? type;
  String? primary;
  String? display;
  String? ref;

  factory MultiValuesAttribute.fromJson(Map<String, dynamic> json) {
    final value = json['value'] as String;
    final type = json['type'] as String;
    final primary = json['primary'] as String;
    final display = json['display'] as String;
    final ref = json['\$ref'] as String;

    return MultiValuesAttribute(value: value, type: type, primary: primary, display: display, ref: ref);
  }
  Map<String, dynamic> toJson() {
    return {'value': value, 'type': type, 'primary': primary, 'display': display, 'ref': ref};
  }
}
