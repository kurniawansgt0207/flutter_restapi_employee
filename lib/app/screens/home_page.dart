import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_employees_restapi/app/data/model/employee_model.dart';
import 'package:flutter_employees_restapi/app/data/service/employee_service.dart';
import 'package:flutter_employees_restapi/app/screens/formentry.dart';
import 'dart:developer';

import 'package:flutter_employees_restapi/main.dart';

enum SortType { name, email, designation }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Employee>? employees;
  List<Employee>? initEmployees = null;
  bool isLoading = true;
  bool showSearchField = false;
  SortType sortType = SortType.name;

  final EmployeeService api = EmployeeService();

  @override
  void initState() {
    super.initState();

    loadEmployees();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: getAppBar(),
        floatingActionButton: getFAB(context),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: getWidget(),
          ),
        ));
  }

  Future<void> loadEmployees() async {
    final employeeService = EmployeeService();
    initEmployees = await employeeService.getAllEmployees();
    employees = initEmployees;
    log('count: ${employees!.length}');
    sortEmployees(SortType.name);
  }

  void searchEmployees(String place) {
    if (initEmployees != null) {
      setState(() {
        employees = initEmployees!
            .where((c) =>
                (c.name != null && c.name!.isNotEmpty
                    ? c.name!.toLowerCase().contains(place.toLowerCase())
                    : false) ||
                (c.email != null && c.email!.isNotEmpty
                    ? c.email!.toLowerCase().contains(place.toLowerCase())
                    : false) ||
                (c.designation != null && c.designation!.isNotEmpty
                    ? c.designation!.toLowerCase().contains(place.toLowerCase())
                    : false))
            .toList();
      });
    }
  }

  Future<void> sortEmployees(SortType type) async {
    setState(() {
      isLoading = true;
      sortType = type;
    });
    if (employees != null) {
      employees!.sort((a, b) {
        switch (type) {
          case SortType.name:
            final nameA = a.name != null && a.name!.isNotEmpty
                ? a.name?.toLowerCase()
                : null;
            final nameB = b.name != null && b.name!.isNotEmpty
                ? b.name?.toLowerCase()
                : null;
            if (nameA != null && nameB != null) {
              return nameA.compareTo(nameB);
            }
            return 0;
          case SortType.email:
            final nameA = a.email != null && a.email!.isNotEmpty
                ? a.email?.toLowerCase()
                : null;
            final nameB = b.email != null && b.email!.isNotEmpty
                ? b.email?.toLowerCase()
                : null;
            if (nameA != null && nameB != null) {
              return nameA.compareTo(nameB);
            }
            return 0;
          case SortType.designation:
            final nameA = a.designation != null && a.designation!.isNotEmpty
                ? a.designation?.toLowerCase()
                : null;
            final nameB = b.designation != null && b.designation!.isNotEmpty
                ? b.designation?.toLowerCase()
                : null;
            if (nameA != null && nameB != null) {
              return nameA.compareTo(nameB);
            }
            return 0;
          default:
            return 0;
        }
      });
    }

    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      isLoading = false;
    });
  }

  Row getFAB(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        showSearchField
            ? Flexible(
                child: Container(
                  margin: const EdgeInsets.only(left: 20),
                  constraints:
                      const BoxConstraints(maxWidth: 500, minWidth: 200),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 3,
                          offset: const Offset(0, 1)),
                      BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4)),
                    ],
                  ),
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    enabled: true,
                    onChanged: searchEmployees,
                  ),
                ),
              )
            : Container(),
        const SizedBox(width: 8),
        FloatingActionButton(
          tooltip: 'Search',
          onPressed: () {
            setState(() {
              if (showSearchField) {
                searchEmployees('');
              }
              showSearchField = !showSearchField;
            });
          },
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) => RotationTransition(
                    turns: child.key == const ValueKey('icon1')
                        ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                        : Tween<double>(begin: 0.75, end: 1).animate(anim),
                    child: ScaleTransition(scale: anim, child: child),
                  ),
              child: showSearchField
                  ? const Icon(Icons.close, key: ValueKey('icon1'))
                  : const Icon(Icons.search, key: ValueKey('icon2'))),
        ),
        const SizedBox(width: 8),
        FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Tambah Data',
            onPressed: () {
              ToEntryForm(
                  context, Employee(name: "", email: "", designation: ""));
            }),
      ],
    );
  }

  AppBar getAppBar() {
    return AppBar(
      title: Container(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: Row(
          children: [
            getAppBarButton(SortType.name),
            const SizedBox(width: 8),
            getAppBarButton(SortType.email),
            const SizedBox(width: 8),
            getAppBarButton(SortType.designation),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Aksi',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Expanded getAppBarButton(SortType type) {
    final text = type == SortType.name
        ? 'Name'
        : type == SortType.email
            ? 'Email'
            : 'Designation';
    return Expanded(
      child: GestureDetector(
        onTap: () => sortEmployees(type),
        child: Container(
          padding: const EdgeInsets.only(
            bottom: 5,
          ),
          decoration: sortType == type
              ? const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                )))
              : null,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget getWidget() {
    if (employees == null || isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (employees!.isEmpty) {
      return const Center(
        child: Text('No employee found!'),
      );
    } else {
      return SingleChildScrollView(
        child: SelectionArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                for (var employee in employees!) ...{
                  Container(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(employee.name != null &&
                                    employee.name!.isNotEmpty
                                ? employee.name!
                                : 'No name')),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(employee.email != null &&
                                  employee.email!.isNotEmpty
                              ? employee.email!
                              : 'No email'),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(employee.designation != null &&
                                  employee.designation!.isNotEmpty
                              ? employee.designation!.length == 1
                                  ? employee.designation!
                                  : employee.designation.toString()
                              : 'No desgination'),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Tooltip(
                                  message: "Hapus Data",
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Konfirmasi"),
                                            content: Text(
                                                "Apakah Anda ingin menghapus item ini? (${employee.name})"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  // Tambahkan logika untuk menghapus item
                                                  log("ID : ${employee.id}");
                                                  api.deleteEmplpyee(
                                                      employee.id!);
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyApp()),
                                                  );
                                                },
                                                child: Text("Ya"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Tidak"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5.0),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Tooltip(
                                  message: "Ubah Data",
                                  child: GestureDetector(
                                    onTap: () {
                                      ToEntryForm(
                                          context,
                                          Employee(
                                              id: employee.id,
                                              name: employee.name,
                                              email: employee.email,
                                              designation:
                                                  employee.designation));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: const Divider(),
                  )
                }
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<Employee> ToEntryForm(BuildContext context, Employee? employee) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(employee!);
    }));
    return result;
  }
}
