class Contact {
  String name;
  String email;
  int id;

  Contact({this.name, this.email});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['email'] = email;

    return map;
  }

  Contact.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.email = map['email'];
  }
}
