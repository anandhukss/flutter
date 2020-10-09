class Data {
  int id;
  String name;
  Data(this.id, this.name);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'name': name};
    return map;
  }

  Data.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}
