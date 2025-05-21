class ToDo {
  int? id;
  String name;

  ToDo({this.id, required this.name});

  factory ToDo.fromMap(Map<String, dynamic> json) => ToDo(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}