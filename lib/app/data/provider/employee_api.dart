import 'dart:convert';

import 'package:flutter_employees_restapi/app/data/model/employee_model.dart';
import 'package:http/http.dart' as http;

class EmployeeApi {
  Future<List<Employee>?> getAllEmployees() async {
    var client = http.Client();

    var uri = Uri.parse('https://cordova-media.com/apps/restapi/api/list');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return employeeFromJson(const Utf8Decoder().convert(response.bodyBytes));
    }
    return null;
  }
}
