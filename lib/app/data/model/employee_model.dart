import 'dart:convert';

List<Employee> employeeFromJson(String str) =>
    List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  int? id = 0;
  String? name = "";
  String? email = "";
  String? designation = "";

  Employee({
    this.id,
    this.name,
    this.email,
    this.designation,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      designation: json["designation"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id == 0 ? null : id,
        "name": name,
        "email": email,
        "designation": designation,
      };
}
