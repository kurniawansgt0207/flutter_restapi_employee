
import 'package:flutter/material.dart';
import 'package:flutter_employees_restapi/app/data/model/employee_model.dart';
import 'package:flutter_employees_restapi/app/data/service/employee_service.dart';
import 'dart:developer';

import 'package:flutter_employees_restapi/app/screens/home_page.dart';

class EntryForm extends StatefulWidget {
  final Employee employee;

  EntryForm(this.employee);

  @override
  EntryFormState createState() => EntryFormState(this.employee);
}

class EntryFormState extends State<EntryForm> {
  Employee employee;

  EntryFormState(this.employee);

  TextEditingController idCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController designationCtrl = TextEditingController();

  final EmployeeService api = EmployeeService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (employee != Null) {
      idCtrl.text = employee.id.toString();
      nameCtrl.text = employee.name!;
      emailCtrl.text = employee.email!;
      designationCtrl.text = employee.designation!;
    }

    return Scaffold(
      appBar: AppBar(
        title: employee.name == "" ? Text('Tambah') : Text('Ubah'),
        leading: Icon(Icons.keyboard_arrow_left),
      ),
      body:
        Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Visibility(
                visible: true,
                child: TextFormField(
                  controller: idCtrl,
                  keyboardType: TextInputType.number,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextFormField(
                  controller: nameCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'NAMA LENGKAP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Silahkan isi NAMA LENGKAP.';
                    }
                    return null; // Return null if the input is valid.
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-MAIL',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    print("ini input email");
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Silahkan isi E-MAIL.';
                    }
                    return null; // Return null if the input is valid.
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextFormField(
                  controller: designationCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'DESIGNATION',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Silahkan isi DESIGNATION.';
                    }
                    return null; // Return null if the input is valid.
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            log('aaa ${idCtrl.text} ${nameCtrl.text} ${emailCtrl.text} ${designationCtrl.text}');
                            if (idCtrl.text != "null") {
                              log("Update");
                              api.updateEmployee(Employee(
                                id: int.parse(idCtrl.text),
                                name: nameCtrl.text,
                                email: emailCtrl.text,
                                designation: designationCtrl.text,
                              ));
                            } else {
                              log("Insert");
                              api.createEmployee(Employee(
                                name: nameCtrl.text,
                                email: emailCtrl.text,
                                designation: designationCtrl.text,
                              ));
                            }
                            //Navigator.pop(context, employee);
                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(builder: (context) => HomePage())
                            );
                          }
                        },
                        child: const Text('Simpan'),
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, employee);
                        },
                        child: const Text('Batal'),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
