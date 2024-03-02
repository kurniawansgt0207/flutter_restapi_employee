import 'dart:convert';
import 'package:flutter_employees_restapi/app/data/model/employee_model.dart';
import 'package:http/http.dart' as http;

class EmployeeService {

  final String apiUrl = "https://cordova-media.com/apps/restapi/api";

  Future<List<Employee>?> getAllEmployees() async {
    var client = http.Client();

    var uri = Uri.parse(apiUrl + '/list');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return employeeFromJson(const Utf8Decoder().convert(response.bodyBytes));
    }
    return null;
  }

  Future<Employee?> createEmployee(Employee employee) async {
    Map data = {
      'name': employee.name,
      'email': employee.email,
      'designation': employee.designation,
    };

    print(data);
    var client = http.Client();

    var uri = Uri.parse(apiUrl + '/store');
    var response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post cases');
    }
  }

  Future<Employee?> updateEmployee(Employee employee) async {
    Map data = {
      'id': employee.id,
      'name': employee.name,
      'email': employee.email,
      'designation': employee.designation,
    };

    print(data);
    var client = http.Client();

    var uri = Uri.parse(apiUrl + '/update');
    var response = await client.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return Employee.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post cases');
    }
  }

  Future<void> deleteEmplpyee(int id) async {
    var client = http.Client();

    var uri = Uri.parse(apiUrl + '/delete/$id');

    var response = await client.delete(uri);

    if (response.statusCode == 200) {
      print("Case deleted");
    } else {
      throw "Failed to delete a case.";
    }
  }
}
